include(ExternalProject)

# Options
option(FORCE_OPENCV_BUILD "OpenCV: force build" OFF)

# Try finding OpenCV
if(NOT FORCE_OPENCV_BUILD)
  find_package(OpenCV QUIET HINTS ${OpenCV_DIR})
endif()

# Check if OpenCV has been found
if(OpenCV_FOUND AND NOT FORCE_OPENCV_BUILD)

  # Status message
  message(STATUS "Found OpenCV (version ${OpenCV_VERSION}): ${OpenCV_DIR}")

else()

  # Git repository URL and tag
  if(NOT OPENCV_URL)
    set(OPENCV_URL https://github.com/opencv/opencv.git)
  endif()
  if(NOT OPENCV_TAG)
    set(OPENCV_TAG "2.4.13")
  endif()
  message(STATUS "Will pull OpenCV (tag ${OPENCV_TAG}) from ${OPENCV_URL}")

  # OpenCV build options
  if(NOT OPENCV_BUILD_TYPE)
    set(OPENCV_BUILD_TYPE ${CMAKE_BUILD_TYPE})
  endif()
  option(OPENCV_BUILD_DOCS "OpenCV: Create build rules for OpenCV Documentation" OFF)
  option(OPENCV_BUILD_EXAMPLES "OpenCV: Build all examples" OFF)
  option(OPENCV_BUILD_PERF_TESTS "OpenCV: Build performance tests" OFF)
  option(OPENCV_BUILD_TESTS "OpenCV: Build accuracy & regression tests" OFF)
  option(OPENCV_WITH_CUDA "OpenCV: Include NVidia Cuda Runtime support" OFF)
  option(OPENCV_WITH_IPP "OpenCV: Include Intel IPP support" OFF) # Causes a hash mismatch error when downloading
  option(OPENCV_WITH_GPHOTO "OpenCV: Include gPhoto2 library support" OFF) # Causes a compilation error

  option(WITH_1394 "" OFF)
  option(WITH_AVFOUNDATION "" OFF)
  option(WITH_CARBON "" OFF)
  option(WITH_VTK "" OFF)
  option(WITH_CUFFT "" OFF)
  option(WITH_CUBLAS "" OFF)
  option(WITH_NVCUVID "" OFF)
  option(WITH_EIGEN "" OFF)
  option(WITH_VFW "" OFF)
  option(WITH_FFMPEG "" OFF)
  option(WITH_GSTREAMER "" OFF)
  option(WITH_GSTREAMER_0_10 "" OFF)
  option(WITH_GTK "" OFF)
  option(WITH_IMAGEIO "" OFF)
  option(WITH_JASPER "" OFF)
  option(WITH_JPEG "" ON)
  option(WITH_OPENEXR "" OFF)
  option(WITH_OPENGL "" OFF)
  option(WITH_OPENNI "" OFF)
  option(WITH_PNG "" ON)
  option(WITH_PVAPI "" OFF)
  option(WITH_GIGEAPI "" OFF)
  option(WITH_QT "" OFF)
  option(WITH_WIN32UI "" OFF)
  option(WITH_QUICKTIME "" OFF)
  option(WITH_TBB "" OFF)
  option(WITH_OPENMP "" OFF)
  option(WITH_CSTRIPES "" OFF)
  option(WITH_TIFF "" ON)
  option(WITH_UNICAP "" OFF)
  option(WITH_V4L "" OFF)
  option(WITH_LIBV4L "" OFF)
  option(WITH_DSHOW "" OFF)
  option(WITH_MSMF "" OFF)
  option(WITH_XIMEA "" OFF)
  option(WITH_XINE "" OFF)
  option(WITH_OPENCL "" OFF)
  option(WITH_OPENCLAMDFFT "" OFF)
  option(WITH_OPENCLAMDBLAS "" OFF)
  option(WITH_INTELPERC "" OFF)
  option(BUILD_SHARED_LIBS "" OFF)
  option(BUILD_opencv_apps "" OFF)
  option(BUILD_ANDROID_EXAMPLES "" OFF)
  option(BUILD_PACKAGE "" OFF)
  option(BUILD_WITH_DEBUG_INFO "" OFF)
  option(BUILD_WITH_STATIC_CRT "" OFF)
  option(BUILD_FAT_JAVA_LIB "" OFF)
  option(BUILD_ANDROID_SERVICE "" OFF)
  option(BUILD_ANDROID_PACKAGE "" OFF)
  option(BUILD_TINY_GPU_MODULE "" OFF)
  option(BUILD_ZLIB "" ON)
  option(BUILD_TIFF "" ON)
  option(BUILD_JASPER "" OFF)
  option(BUILD_JPEG "" ON)
  option(BUILD_PNG "" ON)
  option(BUILD_OPENEXR "" OFF)
  option(BUILD_TBB "" OFF)
  option(INSTALL_CREATE_DISTRIB "" OFF)
  option(INSTALL_C_EXAMPLES "" OFF)
  option(INSTALL_PYTHON_EXAMPLES "" OFF)
  option(INSTALL_ANDROID_EXAMPLES "" OFF)
  option(INSTALL_TO_MANGLED_PATHS "" OFF)
  option(INSTALL_TESTS "" OFF)
  option(ENABLE_DYNAMIC_CUDA "" OFF)
  option(ENABLE_PRECOMPILED_HEADERS "" OFF)
  option(ENABLE_SOLUTION_FOLDERS "" OFF)
  option(ENABLE_PROFILING "" OFF)
  option(ENABLE_COVERAGE "" OFF)
  option(ENABLE_OMIT_FRAME_POINTER "" OFF)
  option(ENABLE_POWERPC "" OFF)
  option(ENABLE_FAST_MATH "" OFF)
  option(ENABLE_SSE "" OFF)
  option(ENABLE_SSE2 "" OFF)
  option(ENABLE_SSE3 "" OFF)
  option(ENABLE_SSSE3 "" OFF)
  option(ENABLE_SSE41 "" OFF)
  option(ENABLE_SSE42 "" OFF)
  option(ENABLE_AVX "" OFF)
  option(ENABLE_AVX2 "" OFF)
  option(ENABLE_NEON "" OFF)
  option(ENABLE_VFPV3 "" OFF)
  option(ENABLE_NOISY_WARNINGS "" OFF)
  option(OPENCV_WARNINGS_ARE_ERRORS "" OFF)
  option(ENABLE_WINRT_MODE "" OFF)
  option(ENABLE_WINRT_MODE_NATIVE "" OFF)
  option(ENABLE_LIBVS2013 "" OFF)
  option(ENABLE_WINSDK81 "" OFF)
  option(ENABLE_WINPHONESDK80 "" OFF)
  option(ENABLE_WINPHONESDK81 "" OFF)
  #option(CMAKE_VERBOSE "" OFF)

  # Download and build location
  set(OPENCV_SOURCE_DIR ${PROJECT_BINARY_DIR}/download/opencv/source)
  set(OPENCV_BINARY_DIR ${PROJECT_BINARY_DIR}/download/opencv/build)

  # Get OpenCV from Git repository and build
  ExternalProject_Add(project_OpenCV
    PREFIX          ${CMAKE_INSTALL_PREFIX}
    TMP_DIR         ${OPENCV_BINARY_DIR}/tmp
    STAMP_DIR       ${OPENCV_BINARY_DIR}/stamp
    GIT_REPOSITORY  ${OPENCV_URL}
    GIT_TAG         ${OPENCV_TAG}
    SOURCE_DIR      ${OPENCV_SOURCE_DIR}
    BINARY_DIR      ${OPENCV_BINARY_DIR}
    BUILD_COMMAND   ${CMAKE_MAKE_PROGRAM} -j${MAKE_NUM_PROCESSES} VERBOSE=${VERBOSE}
    INSTALL_DIR     ${CMAKE_INSTALL_PREFIX}
    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install -j${MAKE_NUM_PROCESSES} VERBOSE=${VERBOSE}
    CMAKE_ARGS
      -D CMAKE_INSTALL_PREFIX=${CMAKE_INSTALL_PREFIX}
      -D CMAKE_INSTALL_MESSAGE=${CMAKE_INSTALL_MESSAGE}
      -D CMAKE_BUILD_TYPE=${OPENCV_BUILD_TYPE}
      -D WITH_CUDA=${OPENCV_WITH_CUDA}
      -D WITH_IPP=${OPENCV_WITH_IPP}
      -D WITH_GPHOTO2=${OPENCV_WITH_GPHOTO2}
      -D BUILD_DOCS=${OPENCV_BUILD_DOCS}
      -D BUILD_EXAMPLES=${OPENCV_BUILD_EXAMPLES}
      -D BUILD_PERF_TESTS=${OPENCV_BUILD_PERF_TESTS}
      -D BUILD_TESTS=${OPENCV_BUILD_TESTS}
      -D BUILD_opencv_java=OFF
      -D CMAKE_SKIP_BUILD_RPATH=${CMAKE_SKIP_BUILD_RPATH}
      -D CMAKE_BUILD_WITH_INSTALL_RPATH=${CMAKE_BUILD_WITH_INSTALL_RPATH}
      -D CMAKE_INSTALL_RPATH_USE_LINK_PATH=${CMAKE_INSTALL_RPATH_USE_LINK_PATH}
      -D CMAKE_INSTALL_RPATH=${CMAKE_INSTALL_RPATH}
      -D CMAKE_MACOSX_RPATH=${CMAKE_MACOSX_RPATH}
      -D WITH_1394=${WITH_1394}
      -D WITH_AVFOUNDATION=${WITH_AVFOUNDATION}
      -D WITH_CARBON=${WITH_CARBON}
      -D WITH_VTK=${WITH_VTK}
      -D WITH_CUFFT=${WITH_CUFFT}
      -D WITH_CUBLAS=${WITH_CUBLAS}
      -D WITH_NVCUVID=${WITH_NVCUVID}
      -D WITH_EIGEN=${WITH_EIGEN}
      -D WITH_VFW=${WITH_VFW}
      -D WITH_FFMPEG=${WITH_FFMPEG}
      -D WITH_GSTREAMER=${WITH_GSTREAMER}
      -D WITH_GSTREAMER_0_10=${WITH_GSTREAMER_0_10}
      -D WITH_GTK=${WITH_GTK}
      -D WITH_IMAGEIO=${WITH_IMAGEIO}
      -D WITH_JASPER=${WITH_JASPER}
      -D WITH_JPEG=${WITH_JPEG}
      -D WITH_OPENEXR=${WITH_OPENEXR}
      -D WITH_OPENGL=${WITH_OPENGL}
      -D WITH_OPENNI=${WITH_OPENNI}
      -D WITH_PNG=${WITH_PNG}
      -D WITH_PVAPI=${WITH_PVAPI}
      -D WITH_GIGEAPI=${WITH_GIGEAPI}
      -D WITH_QT=${WITH_QT}
      -D WITH_WIN32UI=${WITH_WIN32UI}
      -D WITH_QUICKTIME=${WITH_QUICKTIME}
      -D WITH_TBB=${WITH_TBB}
      -D WITH_OPENMP=${WITH_OPENMP}
      -D WITH_CSTRIPES=${WITH_CSTRIPES}
      -D WITH_TIFF=${WITH_TIFF}
      -D WITH_UNICAP=${WITH_UNICAP}
      -D WITH_V4L=${WITH_V4L}
      -D WITH_LIBV4L=${WITH_LIBV4L}
      -D WITH_DSHOW=${WITH_DSHOW}
      -D WITH_MSMF=${WITH_MSMF}
      -D WITH_XIMEA=${WITH_XIMEA}
      -D WITH_XINE=${WITH_XINE}
      -D WITH_OPENCL=${WITH_OPENCL}
      -D WITH_OPENCLAMDFFT=${WITH_OPENCLAMDFFT}
      -D WITH_OPENCLAMDBLAS=${WITH_OPENCLAMDBLAS}
      -D WITH_INTELPERC=${WITH_INTELPERC}
      -D BUILD_SHARED_LIBS=${BUILD_SHARED_LIBS}
      -D BUILD_opencv_apps=${BUILD_opencv_apps}
      -D BUILD_ANDROID_EXAMPLES=${BUILD_ANDROID_EXAMPLES}
      -D BUILD_PACKAGE=${BUILD_PACKAGE}
      -D BUILD_WITH_DEBUG_INFO=${BUILD_WITH_DEBUG_INFO}
      -D BUILD_WITH_STATIC_CRT=${BUILD_WITH_STATIC_CRT}
      -D BUILD_FAT_JAVA_LIB=${BUILD_FAT_JAVA_LIB}
      -D BUILD_ANDROID_SERVICE=${BUILD_ANDROID_SERVICE}
      -D BUILD_ANDROID_PACKAGE=${BUILD_ANDROID_PACKAGE}
      -D BUILD_TINY_GPU_MODULE=${BUILD_TINY_GPU_MODULE}
      -D BUILD_ZLIB=${BUILD_ZLIB}
      -D BUILD_TIFF=${BUILD_TIFF}
      -D BUILD_JASPER=${BUILD_JASPER}
      -D BUILD_JPEG=${BUILD_JPEG}
      -D BUILD_PNG=${BUILD_PNG}
      -D BUILD_OPENEXR=${BUILD_OPENEXR}
      -D BUILD_TBB=${BUILD_TBB}
      -D INSTALL_CREATE_DISTRIB=${INSTALL_CREATE_DISTRIB}
      -D INSTALL_C_EXAMPLES=${INSTALL_C_EXAMPLES}
      -D INSTALL_PYTHON_EXAMPLES=${INSTALL_PYTHON_EXAMPLES}
      -D INSTALL_ANDROID_EXAMPLES=${INSTALL_ANDROID_EXAMPLES}
      -D INSTALL_TO_MANGLED_PATHS=${INSTALL_TO_MANGLED_PATHS}
      -D INSTALL_TESTS=${INSTALL_TESTS}
      -D ENABLE_DYNAMIC_CUDA=${ENABLE_DYNAMIC_CUDA}
      -D ENABLE_PRECOMPILED_HEADERS=${ENABLE_PRECOMPILED_HEADERS}
      -D ENABLE_SOLUTION_FOLDERS=${ENABLE_SOLUTION_FOLDERS}
      -D ENABLE_PROFILING=${ENABLE_PROFILING}
      -D ENABLE_COVERAGE=${ENABLE_COVERAGE}
      -D ENABLE_OMIT_FRAME_POINTER=${ENABLE_OMIT_FRAME_POINTER}
      -D ENABLE_POWERPC=${ENABLE_POWERPC}
      -D ENABLE_FAST_MATH=${ENABLE_FAST_MATH}
      -D ENABLE_SSE=${ENABLE_SSE}
      -D ENABLE_SSE2=${ENABLE_SSE2}
      -D ENABLE_SSE3=${ENABLE_SSE3}
      -D ENABLE_SSSE3=${ENABLE_SSSE3}
      -D ENABLE_SSE41=${ENABLE_SSE41}
      -D ENABLE_SSE42=${ENABLE_SSE42}
      -D ENABLE_AVX=${ENABLE_AVX}
      -D ENABLE_AVX2=${ENABLE_AVX2}
      -D ENABLE_NEON=${ENABLE_NEON}
      -D ENABLE_VFPV3=${ENABLE_VFPV3}
      -D ENABLE_NOISY_WARNINGS=${ENABLE_NOISY_WARNINGS}
      -D OPENCV_WARNINGS_ARE_ERRORS=${OPENCV_WARNINGS_ARE_ERRORS}
      -D ENABLE_WINRT_MODE=${ENABLE_WINRT_MODE}
      -D ENABLE_WINRT_MODE_NATIVE=${ENABLE_WINRT_MODE_NATIVE}
      -D ENABLE_LIBVS2013=${ENABLE_LIBVS2013}
      -D ENABLE_WINSDK81=${ENABLE_WINSDK81}
      -D ENABLE_WINPHONESDK80=${ENABLE_WINPHONESDK80}
      -D ENABLE_WINPHONESDK81=${ENABLE_WINPHONESDK81}
      -D CMAKE_VERBOSE=${CMAKE_VERBOSE}
  )

  # Get install directory
  set(OpenCV_DIR ${CMAKE_INSTALL_PREFIX})

  # Get header files
  set(OpenCV_INCLUDE_DIRS ${OpenCV_DIR}/include)

  # Get libraries
  set(OpenCV_LIBRARIES
    ${OpenCV_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}opencv_core${CMAKE_SHARED_LIBRARY_SUFFIX}
    ${OpenCV_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}opencv_imgproc${CMAKE_SHARED_LIBRARY_SUFFIX}
    ${OpenCV_DIR}/lib/${CMAKE_SHARED_LIBRARY_PREFIX}opencv_highgui${CMAKE_SHARED_LIBRARY_SUFFIX}
  )

  # LBANN has built OpenCV
  set(LBANN_BUILT_OPENCV TRUE)

endif()

# Include header files
include_directories(${OpenCV_INCLUDE_DIRS})

# Add preprocessor flag for OpenCV
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -D__LIB_OPENCV")

# LBANN has access to OpenCV
set(LBANN_HAS_OPENCV TRUE)
