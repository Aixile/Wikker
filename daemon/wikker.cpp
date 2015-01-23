# include "wikker.h"

int MaxNodeID;

u64 getHash(const char* name){
	int l=strlen(name);
	u64 h=0;
	for(int i=0;i<l;i++){
		h*=M;h+=name[i];
	}
	return h;
}

u64 getHash(string &name){
	int l=name.length();
	u64 h=0;
	for(int i=0;i<l;i++){
		h*=M;h+=name[i];
	}
	return h;
}

inline void addEdge(int s,int t){
	node[s].eList.push_back(t);
}

inline int readInt(char * &s){
	int ans=0; 
	while(!((*s)>='0'&&(*s)<='9')&&(*s)!=0)	s++;
	if((*s)==0)	return -1;
	while((*s)>='0'&&(*s)<='9')	ans*=10,ans+=(*s)-'0',s++;
	return ans;
}

void readNameMap(){
	FILE * readFile;
	int lSize;
	time_t s_c,e_c;
	s_c=time(NULL);

	readFile=fopen(namePath.c_str(),"rb");
	if(readFile==NULL){
		cerr<<"Couldn't find "<<namePath<<endl;
		exit(1);
	}
	fseek(readFile,0,SEEK_END);
	lSize=ftell(readFile);
	rewind(readFile);
	register char *buffer,*buffer_bak;
	buffer=(char *)malloc(sizeof(char)*lSize);
	fread(buffer,1,lSize,readFile);

	buffer_bak=buffer;
	string name;
	hashedName.clear();
	int cnt=0;
	u64 h=0;int oldID;

	while(*buffer){
		if((*buffer)=='\r'){
			buffer++;
			continue;
		}
		if((*buffer)==' '){
			oldID=readInt(buffer);
			continue;
		}

		if((*buffer)=='\n'){
			if(hashedName[h]!=0){
				cerr<<"Hash Conflict!!"<<endl;
			}
			hashedName[h]=++cnt;
			node[cnt].name=name;
			newID[oldID]=cnt;
			name="";
			h=0;
		}else{
			name+=*buffer;
			h*=M;h+=*buffer;
		}
		buffer++;
	}
	MaxNodeID=cnt;

	free(buffer_bak);
	e_c=time(NULL);
	cout<<"ReadName: Reading Complete! Total Time is "<<difftime(e_c,s_c)<<"s"<<endl;
}

void readLink(){
	FILE * readFile;
	int lSize;
	time_t s_c,e_c;
	s_c=time(NULL);

	readFile=fopen(linkPath.c_str(),"rb");
	if(readFile==NULL){
		cerr<<"Coundn't find "<<linkPath<<endl;
		exit(1);
	}
	fseek(readFile,0,SEEK_END);
	lSize=ftell(readFile);
	rewind(readFile);
	register char *buffer,*buffer_bak;
	buffer=(char *)malloc(sizeof(char)*lSize);
	fread(buffer,1,lSize,readFile);

	int val,oldID=0;
	buffer_bak=buffer;

	while((val=readInt(buffer))>=0){
		int id=newID[val],deg=readInt(buffer);
		while(deg--){
			addEdge(id,newID[readInt(buffer)]);
		}
	}

	free(buffer_bak);
	e_c=time(NULL);
	cout<<"ReadEdge: Reading Complete! Total Time is "<<difftime(e_c,s_c)<<"s"<<endl;
}

void readRedirect(){
	FILE * readFile; 
	int lSize;
	time_t s_c,e_c;
	s_c=time(NULL);

	readFile=fopen(redirectPath.c_str(),"rb");
	if(readFile==NULL){
		cerr<<"Coundn't find "<<redirectPath<<endl;
		exit(1);
	}
	fseek(readFile,0,SEEK_END);
	lSize=ftell(readFile);
	rewind(readFile);
	register char *buffer,*buffer_bak;
	buffer=(char *)malloc(sizeof(char)*lSize);
	fread(buffer,1,lSize,readFile);

	int val,ID=0;
	buffer_bak=buffer;
	for(int i=1;i<=MaxNodeID;i++)	father[i]=i;

	while((val=readInt(buffer))>=0){
		int sonVal=newID[val],faVal=newID[readInt(buffer)],type=readInt(buffer);
		if(type){
			node[sonVal].eList=node[faVal].eList;
		}else{
			father[sonVal]=faVal;
			node[sonVal].eList.clear();
		}
	}
	
	free(buffer_bak);
	e_c=time(NULL);
	cout<<"ReadRedirect: Reading Complete! Total Time is "<<difftime(e_c,s_c)<<"s"<<endl;
}


void getForbiddenCountry(){
	ifstream country(countryPath.c_str());
	if(!country){
		cout<<"Error! :Coundn't find "<<countryPath<<endl;
		return;
	}
	string cname;
	while(country>>cname){
		u64 h=getHash(cname);
		int id=hashedName[h];
		if(!id){
			cout<<"Warrning! forbidden word not found: "<<cname<<endl;
			continue;
		}
		id=father[id];
		node[id].flag|=FLAG_COUNTRY;
	}
}

void getForbiddenDate(){
	ifstream date(datePath.c_str());
	if(!date){
		cout<<"Error! :Coundn't find "<<datePath<<endl;
		return;
	}
	string dname;
	while(date>>dname){
		u64 h=getHash(dname);
		int id=hashedName[h];
		if(!id){
			cout<<"Warrning! forbidden word not found: "<<dname<<endl;
			continue;
		}
		id=father[id];
		node[id].flag|=FLAG_DATE;
	}
}

void getForbiddenAlphabet(){
	ifstream alphabet(alphabetPath.c_str());
	if(!alphabet){
		cout<<"Error! :Coundn't find "<<alphabetPath<<endl;
		return;
	}
	string aname;
	while(alphabet>>aname){
		u64 h=getHash(aname);
		int id=hashedName[h];
		if(!id){
			cout<<"Warrning! forbidden word not found: "<<aname<<endl;
			return;
		}
		id=father[id];
		node[id].flag|=FLAG_ALPHABET;
	}
}

bool bfs(int s,int t,int *dist,int *pre,int flag,bool *forbid,int *first){
	time_t s_c,e_c; 
	memset(dist,-1,sizeof(int)*MaxNodeCnt);
	dist[s]=0;
	queue<int> que;
	que.push(s);
	bool ok=0;
//	if(forbid&&forbid[s])	ok=true;
//	if(forbid&&forbid[t])	ok=true;
	while(!que.empty()){
		int d=que.front();que.pop();
		int e=father[d];
		if(d==t)	ok=true;
		if(d==father[t])	ok=true;
		int a;
		for(vector<int>::iterator i=node[e].eList.begin();i!=node[e].eList.end();i++)	if(dist[a=father[*i]]<0){
			first[a]=*i;
			if(!(node[a].flag&flag)&&(!forbid||!forbid[a])){
				dist[a]=dist[d]+1;
				pre[a]=d;
				que.push(a);
				if(a==t)	ok=true;
			}
		}
		if(ok)	break;
	}
	return dist[t]>=0;
}

void* doProcess(void* arg){
	Socket* socket=(Socket*)arg;
	string buffer;

	json_object* json_output;json_output=json_object_new_object();
	json_object *json_input,*missNode=0,*ansPath=0;
	socket->recv(buffer);
	cout<<buffer<<endl;
	struct timeval timeStart,timeEnd;
	gettimeofday(&timeStart, NULL);
	try {
		json_tokener *tok;tok=json_tokener_new();
		enum json_tokener_error jerr;
		array_list *arr;

		json_input=json_tokener_parse_ex(tok,buffer.c_str(),buffer.length());
		jerr=json_tokener_get_error(tok);
		if(jerr!=json_tokener_success){
			throw(1000);
		}
		int s,t,flag;
		int status=0,haveS=0,haveT=0;
		bool *forbid=0;


		json_object_object_foreach(json_input, key, val){
			if(strcmp(key,"getRandomNode")==0){
				int r=json_object_get_int(val);
				if(r){
					json_object_object_add(json_output,"randomName",json_object_new_string(node[rand()%MaxNodeID+1].name.c_str()));
					throw(0);
				}
			}else if(strcmp(key,"source")==0){
				char const *sname=json_object_get_string(val);
				s=hashedName[getHash(sname)];
				if(!(s>=1&&s<=MaxNodeID)){
					status|=401;
				}
				haveS=1;
			}else if(strcmp(key,"termination")==0){
				char const *tname=json_object_get_string(val);
				t=hashedName[getHash(tname)];
				if(!(t>=1&&t<=MaxNodeID)){
					status|=402;
				}
				haveT=1;
			}else if(strcmp(key,"forbidFlag")==0){
				flag=json_object_get_int(val);
			}else if(strcmp(key,"forbidNode")==0){
				arr=json_object_get_array(val);
				if(arr->length){
					forbid=(bool *)malloc(sizeof(bool)*MaxNodeCnt);
					memset(forbid,false,sizeof(bool)*MaxNodeCnt);
					missNode=json_object_new_array();
					for(int i=0;i<arr->length;i++){
						char const* fname=json_object_get_string((json_object*)arr->array[i]);
						int f=hashedName[getHash(fname)];
						if(!(f>=1&&f<=MaxNodeID)){
							json_object_array_add(missNode,json_object_new_string(fname));
						}else{
							forbid[father[f]]=true;
						}
					}
				}
			}
		}

		if(!haveS||!haveT){
			throw(1000);
		}
		if(status>=400){
			throw(status);
		}

		if(node[father[s]].flag&flag){	// original code : node[s].flag ???why
			throw(node[s].flag+200);
		}

		if(node[father[t]].flag&flag){
			throw(node[t].flag+300);
		}

		if(forbid&&forbid[father[s]]){
			throw(200);
		}

		if(forbid&&forbid[father[t]]){
			throw(300);
		}

		int *dist,*pre,*first,*Stk;int StkTop;

		first=(int *)malloc(sizeof(int)*MaxNodeCnt);
		first[father[s]]=s;
		s=father[s];
		t=father[t];

		dist=(int *)malloc(sizeof(int)*MaxNodeCnt);
		pre=(int *)malloc(sizeof(int)*MaxNodeCnt);
		Stk=(int *)malloc(sizeof(int)*100);
		ansPath=json_object_new_array();
		if(s!=t&&bfs(s,t,dist,pre,flag,forbid,first)){
			StkTop=0;
			int d=t;
			do{
				Stk[StkTop++]=first[d];
				d=pre[d];
			}while(d!=s);
			Stk[StkTop++]=first[d];
			while(StkTop){
				--StkTop;
				json_object_array_add(ansPath,json_object_new_string(node[Stk[StkTop]].name.c_str()));
			}
			status=0;
		}else if(s==t){
			json_object_array_add(ansPath,json_object_new_string(node[first[s]].name.c_str()));
			status=0;
		}else{
			status=100;
		}

		free(dist);
		free(Stk);
		free(first);
		free(pre);
		if(forbid) 	free(forbid);

		throw status;
	}catch(int ex){
		cout<<"ResultCode"<<" "<<ex<<endl;
		json_object_object_add(json_output,"status",json_object_new_int(ex));
	}

	if(ansPath)	json_object_object_add(json_output,"path",ansPath);
	if(missNode)	json_object_object_add(json_output,"missingForbidNode",missNode);
	
	gettimeofday(&timeEnd, NULL);
	int ms_time=(timeEnd.tv_sec-timeStart.tv_sec)*1000+(timeEnd.tv_usec=timeStart.tv_usec)/1000;
	json_object_object_add(json_output,"time",json_object_new_int(ms_time));
	cout<<json_object_to_json_string(json_output)<<endl;
	socket->send(json_object_to_json_string(json_output));

	json_object_put(json_input);
	json_object_put(json_output);
	socket->close();
}


Socket sockets[SocketPoolCnt];
int main(){
	readNameMap();
	readLink();
	readRedirect();

	getForbiddenDate();
	getForbiddenAlphabet();
	getForbiddenCountry();
	for(int i=1;i<=MaxNodeID;i++)	node[i].flag=node[father[i]].flag;	

	int i=0;srand(time(0));
	ServerSocket serversocket(DaemonPort);
	pthread_t tid;
	cout<<"Listening to tcp port "<<DaemonPort<<" ..."<<endl;
	while (true) {
		serversocket.accept(sockets[i]);
		cout<<"Accepted id="<<i<<endl;
		pthread_create(&tid,NULL,doProcess,&sockets[i++]);
		if (i>=SocketPoolCnt) i=0;
	}

}
