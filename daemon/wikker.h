# ifndef PROCESS_H
# define PROCESS_H

# include <cstdio>
# include <cstring>
# include <cstdlib>
# include <iostream>
# include <fstream>
# include <algorithm>
# include <map>
# include <ctime>
# include <queue>
# include <string>
# include <vector>
# include <sstream>
# include <iomanip>
# include <sys/time.h>
# include "pthread.h"
# include "ServerSocket.h"
# include  "json-c/json.h"
using namespace std;

# define FLAG_COUNTRY 1
# define FLAG_DATE 2
# define FLAG_ALPHABET 4

typedef unsigned long long u64;

const u64 M=23456789;
const int MaxNodeCnt=1400000,MaxOutDeg=5000;
const int DaemonPort=15244;
const int SocketPoolCnt=1500;

struct NodeInfo{
	vector<int> eList;
	string name;
	int flag;
	void clear(){
		eList.clear();
		flag=0;
		name="";
	}
} node[MaxNodeCnt];

map<u64,int> hashedName;
map<int,int> newID;
int father[MaxNodeCnt];

const string dirPath=("/home/admin/wikker/daemon/");
const string namePath(dirPath+"map.txt");
const string linkPath(dirPath+"links.txt");
const string redirectPath(dirPath+"redirect.txt");
const string countryPath(dirPath+"country.txt");
const string datePath(dirPath+"date.txt");
const string alphabetPath(dirPath+"alphabet.txt");

# endif
