#include <cstring>
#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <sstream>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/file.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <sys/types.h>
#include <termios.h>
#include <time.h>
#include <unistd.h>

// The errno from the last zwave call
static volatile int64_t lastErrno = 0;

extern "C" {
  // Open the zwave port on the specified port path.
  // Return the file descriptor or a negative value indicating an error.
  int64_t openPort(char* portPath) {
    //tty_fd = open(portPath, O_RDWR | O_NOCTTY | O_NONBLOCK); // NetBSD ??
    int tty_fd = open(portPath, O_RDWR | O_NOCTTY, 0);
    if (tty_fd > 0) {
      if (flock(tty_fd, LOCK_EX | LOCK_NB) == -1) {
        close(tty_fd);
        tty_fd = -33;
      }
    }

    if (tty_fd > 0) {
      int bits;
      bits = 0;
      ioctl(tty_fd, TIOCMSET, &bits);

      struct termios tio;
      memset(&tio, 0, sizeof(tio));

      // Retrieve the current terminal settings
      tcgetattr(tty_fd, &tio);

      // AeoTec Z-Stick = 115200 baud, 8 bits, 1 stop bit, no parity

      // -- baud

      //    cfsetspeed(&tio, B9600);        // 9600 baud
      //    cfsetspeed(&tio, B76800);       // 76800 baud
      cfsetspeed(&tio, B115200);      // 115200 baud

      // -- bits

      tio.c_cflag |= CS8; // 8 bits

      // -- stop bits

      // the default - one stop bit

      // OR alternately - two stop bits
      //    tio.c_cflag |= CSTOPB;

      // -- parity

      tio.c_iflag = IGNPAR; // no parity

      // OR alternately - odd parity
      //    tio.c_iflag = INPCK;
      //    tio.c_cflag = PARENB | PARODD;

      tio.c_cflag |= CREAD;             // Enable receiver
      tio.c_cflag |= CLOCAL;            // Ignore modem control lines

      tio.c_iflag |= IGNBRK;            // Ignore BREAK condition on input
      tio.c_oflag = 0;
      tio.c_lflag = 0;
      for( int i = 0; i < NCCS; i++ ) tio.c_cc[i] = 0;
      tio.c_cc[VMIN] = 0;
      tio.c_cc[VTIME] = 1;

      if (tcsetattr(tty_fd, TCSANOW, &tio) == -1) {
        close(tty_fd);
        tty_fd = -34;
      }
    }

    if (tty_fd > 0) {
      tcflush(tty_fd, TCIOFLUSH);
      lastErrno = 0;
    } else {
      // Record the error if a step failed
      lastErrno = errno;
    }

    return tty_fd;
  }

  // Read message bytes from the given tty file descriptor into the specified list.
  // Return the number of bytes read or a negative return value indicating an error.
  int64_t readBytes(int64_t tty_fd, int64_t maxNumBytesToRead, uint8_t *listPtr) {
    intptr_t numRead = read(tty_fd, listPtr, maxNumBytesToRead);
    if (numRead >= 0) {
      lastErrno = 0;
    } else {
      // return the error code
      lastErrno = errno;
    }
    return numRead;
  }

  // Send the specified message bytes to the given tty file descriptor.
  // Return the number of bytes sent, or a negative return value indicating an error.
  int64_t writeBytes(int64_t tty_fd, int64_t numBytesToWrite, uint8_t *listPtr) {
    lastErrno = 0;
    if (numBytesToWrite <= 0)  return -36;
    if (numBytesToWrite > 255) return -37;
    int64_t result = write(tty_fd, listPtr, numBytesToWrite);
    if (result <= numBytesToWrite) {
      lastErrno = errno;
    }
    return result;
  }

  // Close the zwave port.
  // Return zero if successful or a negative value indicating an error.
  // int _closePort(int ttyFd) native "closePort";
  int64_t closePort(int64_t tty_fd) {
    flock(tty_fd, LOCK_UN);
    int64_t result = close(tty_fd);
    lastErrno = result < 0 ? errno : 0;
    return result;
  }

  // Return the errno from the last I2C command
  // int _lastError() native "lastError";
  int64_t lastError() {
    return lastErrno;
  }
}
