// Definition of the ServerSocket class

#ifndef ServerSocket_class
#define ServerSocket_class

#include "Socket.h"


class ServerSocket : public Socket
{
 public:

  ServerSocket ( int port );
  ServerSocket (){};
  virtual ~ServerSocket();

};


#endif

// Implementation of the ServerSocket class



ServerSocket::ServerSocket ( int port )
{
  create();
  bind ( port );
  listen();
}

ServerSocket::~ServerSocket()
{
}