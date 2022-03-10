#include <stdio.h>

// https://en.wikipedia.org/wiki/STL_(file_format)
// maybe use "ParaView" or "Paint 3D"
void writeStlTriangles(const wchar_t* filename, float* vertices, int stride, int32_t* indices, uint32_t indexCount)
{
    FILE* fileHandle;
    // if (fopen_s(&fileHandle, filename, "wb") != 0)
    if (_wfopen_s(&fileHandle, filename, L"wb") != 0)
    {
        // fprintf(stderr, "Couldn't open file: %s", filename);
        fwprintf(stderr, L"Couldn't open file: %s", filename);
        *((char*)0) = 1;
    }

    // UINT8[80]    – Header                 -     80 bytes                          
    // UINT32       – Number of triangles    -      4 bytes
    // 
    // foreach triangle                      - 50 bytes:
    //     REAL32[3] – Normal vector             - 12 bytes
    //     REAL32[3] – Vertex 1                  - 12 bytes
    //     REAL32[3] – Vertex 2                  - 12 bytes
    //     REAL32[3] – Vertex 3                  - 12 bytes
    //     UINT16    – Attribute byte count      -  2 bytes
    // end

    char buffer[80];
    memset(buffer, 0, sizeof(buffer));
    fwrite(buffer, sizeof(buffer), 1, fileHandle);

    uint32_t triangleCount = indexCount / 3;
    fwrite(&triangleCount, sizeof(triangleCount), 1, fileHandle);

    float normal[3] = { 0.0f, 0.0f, 0.0f };
    uint16_t attributeCount = 0;
    for (uint32_t index = 0; index < indexCount; index += 3)
    {
        fwrite(normal, sizeof(normal), 1, fileHandle);
		fwrite(&vertices[indices[index + 0] * stride], sizeof(float), 3, fileHandle);
		fwrite(&vertices[indices[index + 1] * stride], sizeof(float), 3, fileHandle);
		fwrite(&vertices[indices[index + 2] * stride], sizeof(float), 3, fileHandle);
        fwrite(&attributeCount, sizeof(attributeCount), 1, fileHandle);
    }
    fclose(fileHandle);
}


