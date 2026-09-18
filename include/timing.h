#ifndef TIMING_H
#define TIMING_H

#include <stdint.h>

#ifdef _WIN32
#include <windows.h>

static inline uint64_t monotonic_ns(void) {
	static LARGE_INTEGER frequency;
	static int initialized;
	LARGE_INTEGER counter;

	if (!initialized) {
		QueryPerformanceFrequency(&frequency);
		initialized = 1;
	}
	QueryPerformanceCounter(&counter);
	return (uint64_t)((counter.QuadPart * 1000000000ULL) / frequency.QuadPart);
}
#else
#include <time.h>

static inline uint64_t monotonic_ns(void) {
	struct timespec timestamp;
	clock_gettime(CLOCK_MONOTONIC, &timestamp);
	return (uint64_t)timestamp.tv_sec * 1000000000ULL +
		   (uint64_t)timestamp.tv_nsec;
}
#endif

#endif









#define _POSIX_C_SOURCE 200809L

#include <time.h>
#include <stdint.h>

static inline uint64_t monotonic_ns(void) {
    struct timespec timestamp;
    clock_gettime(CLOCK_MONOTONIC, &timestamp);
    return (uint64_t)timestamp.tv_sec * 1000000000ULL + (uint64_t)timestamp.tv_nsec;
}

