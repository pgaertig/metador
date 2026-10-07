#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include "libraw/libraw.h"

static int data_errors = 0;

/* LibRaw reports corrupted or unsupported data (e.g. Nikon HE NEF) only via this
   callback, unpack() still returns success and the output is noise */
static void data_error_cb(void *data, const char *file, const int offset)
{
  fprintf(stderr, "%s: data corrupted at %d\n", file, offset);
  data_errors++;
}

#define HANDLE_ERROR(ret)                                                                                        \
  if (ret)                                                                                                             \
  {                                                                                                                    \
    fprintf(stderr, "%s: libraw  %s -> %s\n", av[0], av[1], libraw_strerror(ret));                                     \
    if (LIBRAW_FATAL_ERROR(ret))                                                                                       \
      exit(1);                                                                                                         \
  }


int main(int ac, char *av[])
{

  if (ac != 3)
  {
    fprintf(stderr, "Usage: %s <input_file> <output_file>\n %d", av[0],ac);
    exit(1);
  }


  libraw_data_t *iprc = libraw_init(0);

  if (!iprc)
  {
    fprintf(stderr, "Cannot create libraw handle\n");
    exit(1);
  }

  libraw_set_dataerror_handler(iprc, data_error_cb, NULL);

  iprc->params.half_size = 1; /* dcraw -h */
  iprc->params.use_camera_wb = 1; /* dcraw -w */

  char outfn[1024];
  int ret = libraw_open_file(iprc, av[1]);
  HANDLE_ERROR(ret);

  printf("Processing %s (%s %s)\n", av[1], iprc->idata.make, iprc->idata.model);

  ret = libraw_unpack(iprc);
  HANDLE_ERROR(ret);
  if (data_errors)
  {
    libraw_close(iprc);
    exit(1);
  }

  ret = libraw_dcraw_process(iprc);
  HANDLE_ERROR(ret);

  strcpy(outfn, av[2]);
  printf("Writing to %s\n", outfn);

  ret = libraw_dcraw_ppm_tiff_writer(iprc, outfn);
  HANDLE_ERROR(ret);

  libraw_close(iprc);
  return 0;
}
