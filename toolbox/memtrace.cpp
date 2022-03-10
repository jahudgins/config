endif
#if 1 // jhudgins
#include <windows.h>
#include <excpt.h>
#include <imagehlp.h>
#include <psapi.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdbool.h>

#define MAX_SYMBOL_LEN 1024

typedef struct CallstackEntry
{
	DWORD64 offset; // if 0, we have no valid entry
	CHAR	name[MAX_SYMBOL_LEN];
	CHAR	undName[MAX_SYMBOL_LEN];
	CHAR	undFullName[MAX_SYMBOL_LEN];
	DWORD64 offsetFromSmybol;
	DWORD	offsetFromLine;
	DWORD	lineNumber;
	CHAR	lineFileName[MAX_SYMBOL_LEN];
	DWORD	symType;
	LPCSTR  symTypeString;
	CHAR	moduleName[MAX_SYMBOL_LEN];
	DWORD64 baseOfImage;
	CHAR	loadedImageName[MAX_SYMBOL_LEN];
} CallstackEntry;

typedef enum CallstackEntryType
{
	firstEntry,
	nextEntry,
	lastEntry
} CallstackEntryType;

static FILE* sMemtraceFile = NULL;
static HANDLE sMemtraceProcess = NULL;

void _backtrace(char* backtraceString, size_t length)
{
	// Initalize more memory
	CONTEXT context;
	memset(&context, 0, sizeof(CONTEXT));
	context.ContextFlags = CONTEXT_FULL;
	RtlCaptureContext(&context);

	// Initalize a few things here and there
	STACKFRAME stack;
	memset(&stack, 0, sizeof(STACKFRAME));
	stack.AddrPC.Offset		= context.Rip;
	stack.AddrPC.Mode			= AddrModeFlat;
	stack.AddrStack.Offset	= context.Rsp;
	stack.AddrStack.Mode		= AddrModeFlat;
	stack.AddrFrame.Offset	= context.Rbp;
	stack.AddrFrame.Mode		= AddrModeFlat;

#ifdef _M_IX86
	auto machine = IMAGE_FILE_MACHINE_I386;
#elif _M_X64
	auto machine = IMAGE_FILE_MACHINE_AMD64;
#elif _M_IA64
	auto machine = IMAGE_FILE_MACHINE_IA64;
#else
#error "platform not supported!"
#endif
	HANDLE thread = GetCurrentThread();
	for (ULONG frame = 0; ; frame++) {
		BOOL result = StackWalk(machine,
										sMemtraceProcess,
										thread,
										&stack,
										&context,
										0,
										SymFunctionTableAccess,
										SymGetModuleBase,
										0);

		CallstackEntry csEntry;
		csEntry.offset = stack.AddrPC.Offset;
		csEntry.name[0] = 0;
		csEntry.undName[0] = 0;
		csEntry.undFullName[0] = 0;
		csEntry.offsetFromSmybol = 0;
		csEntry.offsetFromLine = 0;
		csEntry.lineFileName[0] = 0;
		csEntry.lineNumber = 0;
		csEntry.loadedImageName[0] = 0;
		csEntry.moduleName[0] = 0;

		IMAGEHLP_SYMBOL64 symbol {};
		symbol.SizeOfStruct = sizeof(IMAGEHLP_SYMBOL64);
		symbol.MaxNameLength = MAX_SYMBOL_LEN;

		// Initalize more memory and clear it out
		if (SymGetSymFromAddr64(sMemtraceProcess,
										stack.AddrPC.Offset,
										&csEntry.offsetFromSmybol,
										&symbol)) {
		}

#if 0 // this overwrites the end of symbol.Name (not sure why)
		IMAGEHLP_LINE64 line {};
		line.SizeOfStruct = sizeof(line);
		if (SymGetLineFromAddr64(process,
											stack.AddrPC.Offset,
											&csEntry.offsetFromLine,
											&line)) {
		}
#endif
		int writeLength = _snprintf_s(backtraceString, length, length, "%s|", symbol.Name);

		// If nothing else to do break loop
		if (!result || writeLength < 0 || frame > 10) {
				break;
		}

		backtraceString += writeLength;
		length -= writeLength;
	}
}

static bool sMemtraceInited = false;
void memtraceStart(const char* memtraceFilename)
{
	if (sMemtraceInited)
	{
		return;
	}
	sMemtraceProcess = ::GetCurrentProcess();
	if (!SymInitialize(sMemtraceProcess, 0, true)) {
		wprintf(L"SymInitialize unable to find process!! Error: %d\n", (int)GetLastError());
		return;
	}
	sMemtraceInited = true;
	DWORD symOptions = SymGetOptions();
	symOptions |= SYMOPT_LOAD_LINES;
	symOptions |= SYMOPT_FAIL_CRITICAL_ERRORS;
	symOptions = SymSetOptions(symOptions);

	if (fopen_s(&sMemtraceFile, memtraceFilename, "wt") != 0)
	{
		*((char*)0) = 1;
	}
	fprintf(sMemtraceFile, "[\n");
}

void memtraceStop()
{
	fprintf(sMemtraceFile, "  [2, \"end\", 0, 0]\n]");
	fclose(sMemtraceFile);
	sMemtraceFile = nullptr;
}

class MemTraceStopper
{
public:
	virtual ~MemTraceStopper() { memtraceStop(); }
};
MemTraceStopper sMemTraceStopper();

void memtraceAlloc(size_t size, void* location)
{
	memtraceStart("C:/work/memtrace.json");
	if (sMemtraceFile == nullptr)
	{
		return;
	}
	char backtraceString[1024];
	_backtrace(backtraceString, sizeof(backtraceString) - 1);
	fprintf(sMemtraceFile, "  [0, \"%s\", %zu, %llu],\n", backtraceString, size, (uint64_t)location);
}

void memtraceFree(void* location)
{
	if (sMemtraceFile == nullptr)
	{
		return;
	}
	char backtraceString[1024];
	_backtrace(backtraceString, sizeof(backtraceString) - 1);
	fprintf(sMemtraceFile, "  [1, \"%s\", 0, %llu],\n", backtraceString, (uint64_t)location);
}

#endif
