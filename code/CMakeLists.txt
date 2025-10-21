cmake_minimum_required (VERSION 3.24)
find_package( ecbuild 3.7 QUIET HINTS ${CMAKE_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/../ecbuild )

project(hands_on VERSION 1 LANGUAGES Fortran)

#find_package(OpenACC REQUIRED)
find_package(OpenMP REQUIRED)
#find_package(fiat REQUIRED)
#find_package(field_api REQUIRED)
set(SRC mod_constants.F90 yomtrc.F90 main.F90 init_ttrc.F90 compute.F90 clean_data.F90)
add_executable(main.x ${SRC})
#target_link_libraries(main.x PRIVATE parkind_dp field_api_dp)   
