#include <stdio.h>
#include <stdint.h>

#include <io.h>
#include <mutex>
std::mutex file_mutex;

void write_tga(const char* filename, int width, int height, uint32_t* data)
{
	int channels = 4;
	uint8_t header[18] = {
		0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		(uint8_t)(width % 256), (uint8_t)(width / 256),
		(uint8_t)(height % 256), (uint8_t)(height / 256),
		(uint8_t)(channels * 8), 0x20
	};
	FILE* f;

	file_mutex.lock();

	int filenameLength = strlen(filebase) + 20;
	char* nextFilename = (char*)malloc(filenameLength);
	int count = 0;
	do
	{
		snprintf(nextFilename, filenameLength, "%s-%d.tga", filebase, count);
		count++;
	}
	while (_access_s(nextFilename, 0) == 0);

	fopen_s(&f, nextFilename, "wb");
	fwrite(&header, sizeof(header), 1, f);
	fwrite(data, width * height * channels, 1, f);
	fclose(f);

	file_mutex.unlock();
	free(nextFilename);
}


void write_channels_rgbaf32(const char* path, const char* filebase, int width, int height, const float* data)
{
	uint8_t* data_b = (uint8_t*)malloc(width * height * 4 * sizeof(uint8_t));
	uint8_t* data_g = (uint8_t*)malloc(width * height * 4 * sizeof(uint8_t));
	uint8_t* data_r = (uint8_t*)malloc(width * height * 4 * sizeof(uint8_t));
	uint8_t* data_a = (uint8_t*)malloc(width * height * 4 * sizeof(uint8_t));
	
	for (int pixel= 0; pixel < height * width; pixel++)
	{
		uint8_t b = (uint8_t)(data[pixel * 4 + 2] * 255);
		uint8_t g = (uint8_t)(data[pixel * 4 + 1] * 255);
		uint8_t r = (uint8_t)(data[pixel * 4] * 255);
		uint8_t a = (uint8_t)(data[pixel * 4 + 3] * 255);
		data_b[pixel * 4 + 0] = b; data_b[pixel * 4 + 1] = 0; data_b[pixel * 4 + 2] = 0; data_b[pixel * 4 + 3] = 255;
		data_g[pixel * 4 + 0] = 0; data_g[pixel * 4 + 1] = g; data_g[pixel * 4 + 2] = 0; data_g[pixel * 4 + 3] = 255;
		data_r[pixel * 4 + 0] = 0; data_r[pixel * 4 + 1] = 0; data_r[pixel * 4 + 2] = r; data_r[pixel * 4 + 3] = 255;
		data_a[pixel * 4 + 0] = a; data_a[pixel * 4 + 1] = a; data_a[pixel * 4 + 2] = a; data_b[pixel * 4 + 3] = 255;
	}

	int filename_length = strlen(path) + strlen(filebase) + 10;
	char* filename_channel = (char*)malloc(filename_length);

	snprintf(filename_channel, filename_length, "%s/%s_r.tga", path, filebase);
	write_tga(filename_channel, width, height, (uint32_t*)data_r);

	snprintf(filename_channel, filename_length, "%s/%s_g.tga", path, filebase);
	write_tga(filename_channel, width, height, (uint32_t*)data_g);

	snprintf(filename_channel, filename_length, "%s/%s_b.tga", path, filebase);
	write_tga(filename_channel, width, height, (uint32_t*)data_b);

	snprintf(filename_channel, filename_length, "%s/%s_a.tga", path, filebase);
	write_tga(filename_channel, width, height, (uint32_t*)data_a);

	free(data_b);
	free(data_g);
	free(data_r);
	free(data_a);
	free(filename_channel);
}

void write_channels_bgra8(const char* path, const char* filebase, int width, int height, const uint8_t* data)
{
	uint8_t* data_b = (uint8_t*)malloc(width * height * 4 * sizeof(uint8_t));
	uint8_t* data_g = (uint8_t*)malloc(width * height * 4 * sizeof(uint8_t));
	uint8_t* data_r = (uint8_t*)malloc(width * height * 4 * sizeof(uint8_t));
	uint8_t* data_a = (uint8_t*)malloc(width * height * 4 * sizeof(uint8_t));
	
	for (int pixel= 0; pixel < height * width; pixel++)
	{
		uint8_t b = data[pixel * 4];
		uint8_t g = data[pixel * 4 + 1];
		uint8_t r = data[pixel * 4 + 2];
		uint8_t a = data[pixel * 4 + 3];

		data_b[pixel * 4 + 0] = b; data_b[pixel * 4 + 1] = 0; data_b[pixel * 4 + 2] = 0; data_b[pixel * 4 + 3] = 255;
		data_g[pixel * 4 + 0] = 0; data_g[pixel * 4 + 1] = g; data_g[pixel * 4 + 2] = 0; data_g[pixel * 4 + 3] = 255;
		data_r[pixel * 4 + 0] = 0; data_r[pixel * 4 + 1] = 0; data_r[pixel * 4 + 2] = r; data_r[pixel * 4 + 3] = 255;
		data_a[pixel * 4 + 0] = a; data_a[pixel * 4 + 1] = a; data_a[pixel * 4 + 2] = a; data_b[pixel * 4 + 3] = 255;
	}

	int filename_length = strlen(path) + strlen(filebase) + 10;
	char* filename_channel = (char*)malloc(filename_length);

	snprintf(filename_channel, filename_length, "%s/%s_r.tga", path, filebase);
	write_tga(filename_channel, width, height, (uint32_t*)data_r);

	snprintf(filename_channel, filename_length, "%s/%s_g.tga", path, filebase);
	write_tga(filename_channel, width, height, (uint32_t*)data_g);

	snprintf(filename_channel, filename_length, "%s/%s_b.tga", path, filebase);
	write_tga(filename_channel, width, height, (uint32_t*)data_b);

	snprintf(filename_channel, filename_length, "%s/%s_a.tga", path, filebase);
	write_tga(filename_channel, width, height, (uint32_t*)data_a);

	free(data_b);
	free(data_g);
	free(data_r);
	free(data_a);
	free(filename_channel);
}


