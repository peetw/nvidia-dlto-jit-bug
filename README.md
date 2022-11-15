# nvidia-dlto-jit-bug

## Overview

The latest NVIDIA GPU driver appears to cause issues for applications compiled as fatbinaries that
also use device link-time optimization (DLTO). When running on a GPU with a newer architecture than
is explicitly compiled for, the application fails with a "device kernel image is invalid" CUDA
error.

For example, a fatbinary application containing PTX for the lowest arch (e.g. `sm_52`), and LTO and
SASS for a number of explicit architectures (e.g. `sm_52` and `sm_61`), is compiled/linked using the
following options:

Compile: `-gencode=arch=compute_52,code=[compute_52,lto_52] -gencode=arch=compute_61,code=lto_61`

Link: `-dlto -gencode=arch=compute_52,code=sm_52 -gencode=arch=compute_61,code=sm_61`

Previously, when running the application on a later GPU arch that wasn't explicitly included in the
fatbinary (e.g. `sm_70` or `sm_86`), the driver (e.g. 516.59) would JIT compile/link the application
and it would run fine. However, after upgrading to the 526.67 driver, the application fails with a
"device kernel image is invalid" CUDA error.

## Requirements

* Windows 10 (or later)
* Visual Studio 2022
* CUDA Toolkit 11.7
* NVIDIA Quadro GPU driver 516.59
* NVIDIA Quadro GPU driver 526.67
* Quadro GPU with CC >= 7.0 (see [here](https://en.wikipedia.org/wiki/CUDA#GPUs_supported))

## Build

Build the VS solution in Release mode.

## Run

Usage: `nvidia-dlto-jit-bug.exe`

## Reproduce Issue

Install the NVIDIA Quadro GPU 516.59 driver and then build/run the example application. It should
run without issue and display the following output:

```
$ nvidia-dlto-jit-bug.exe
PASS
```

Install the NVIDIA Quadro GPU 526.67 driver and then run the example application. It will fail to
run and will display the following output:

```
$ nvidia-dlto-jit-bug.exe
FAIL: device kernel image is invalid
```
