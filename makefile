#help for make
#http://www.cnblogs.com/wang_yb/p/3990952.html
#https://segmentfault.com/a/1190000000349917
#http://blog.csdn.net/cuiyifang/article/details/7910268

#to use gprof to analyse efficience of the program:
#http://blog.chinaunix.net/uid-25194149-id-3215487.html

#to use gcov and lcov
#Notice that optimization should not be used here
#http://blog.163.com/bobile45@126/blog/static/96061992201382025729313/
#gcov -a main.cpp
#lcov --directory .   --capture --output-file dig.info 
#genhtml --output-directory . --frames --show-details dig.info 

#to use doxygen+graphviz+htmlhelp to generate document from source code:
#http://www.doxygen.nl/
#(also include good comments norm)
#http://blog.csdn.net/u010740725/article/details/51387810

#CXX=$(shell which clang 2>/dev/null || which gcc)
#ccache, readline, gcov lcov
#http://blog.csdn.net/u012421852/article/details/52138960
#
# How to speed up the compilation
# https://blog.csdn.net/a_little_a_day/article/details/78251928
# use make -j4, if error then use make utilizing only one thread
#use -j8 or higher may cause error
#http://blog.csdn.net/cscrazybing/article/details/50789482
#http://blog.163.com/liuhonggaono1@126/blog/static/10497901201210254622141/

#compile parameters

# WARN: maybe difficult to install ccache in some systems
#CXX = ccache g++
CXX = g++
CC = gcc

#the optimazition level of gcc/g++
#http://blog.csdn.net/hit_090420216/article/details/44900215
#NOTICE: -O2 is recommended, while -O3(add loop-unroll and inline-function) is dangerous
#when developing, not use -O because it will disturb the normal 
#routine. use it for test and release.
CFLAGS = -c -Wall -O2 -pthread -std=c++11 -Werror=return-type
EXEFLAG = -O2 -pthread -std=c++11 -Werror=return-type
#-coverage for debugging
#CFLAGS = -c -Wall -pthread -O0 -g3 -std=c++11  -gdwarf-2
#EXEFLAG = -pthread -O0 -g3 -std=c++11 -gdwarf-2
#-coverage for debugging and with performance
# CFLAGS = -c -Wall -pthread -g3 -std=c++11  -gdwarf-2 -pg
# EXEFLAG = -pthread -g3 -std=c++11 -gdwarf-2 -pg

#add -lreadline [-ltermcap] if using readline or objs contain readline
# library = -lreadline -L./lib -L/usr/local/lib -lantlr -lgcov -lboost_thread -lboost_filesystem -lboost_system -lboost_regex -lpthread -I/usr/local/include/boost -lcurl
#library = -lreadline -L./lib -L/usr/local/lib -L/usr/lib/ -L./workflow-nossl/_lib -L./workflow-nossl/_include -lantlr4-runtime -lgcov -lboost_thread -lboost_filesystem -lboost_system -lboost_regex -lpthread -I/usr/local/include/boost -lcurl -lworkflow -llog4cplus
#library = -lreadline -L./lib -L/usr/local/lib -L/usr/lib/  -L./3rdparty/workflow-master/_lib -L./3rdparty/workflow-master/_include  -lantlr4-runtime -lgcov -lboost_thread -lboost_filesystem -lboost_system -lboost_regex -lpthread -I/usr/local/include/boost -lcurl  -llog4cplus -lworkflow
#library = -lreadline -L./lib -L/usr/local/lib -L/usr/lib/ -lantlr4-runtime -lgcov -lboost_thread -lboost_filesystem -lboost_system -lboost_regex -lpthread -I/usr/local/include/boost -lcurl -llog4cplus -Wl,-rpath='/usr/local/lib'
library = -L/usr/lib64 -L./lib -L/usr/local/lib -L/usr/lib -I/usr/local/include/boost -ljemalloc -lreadline -lantlr4-runtime -lgcov -lboost_thread -lboost_system -lboost_regex -lpthread -lcurl -llog4cplus -lz -lminizip
#used for parallelsort
march = -march=native
openmp = -fopenmp ${march}
# library = -ltermcap -lreadline -L./lib -lantlr -lgcov
def64IO = -D_FILE_OFFSET_BITS=64 -D_LARGEFILE64_SOURCE -D_LARGEFILE_SOURCE
# load dynamic lib
ldl = -ldl

FIRST_BUILD ?= %.o
# paths

objdir = .objs/

exedir = bin/

testdir = scripts/

lib_antlr = lib/libantlr4-runtime.a

lib_rpc = lib/libworkflow.a

lib_log = lib/liblog4cplus.a

api_cpp = api/http/cpp/lib/libgstoreconnector.a

api_socket = api/socket/cpp/lib/libclient.a

# objects

sitreeobj = $(objdir)SITree.o $(objdir)SIStorage.o $(objdir)SINode.o $(objdir)SIIntlNode.o $(objdir)SILeafNode.o $(objdir)SIHeap.o
ivarrayobj = $(objdir)IVArray.o $(objdir)IVEntry.o $(objdir)IVBlockManager.o
isarrayobj = $(objdir)ISArray.o $(objdir)ISEntry.o $(objdir)ISBlockManager.o

kvstoreobj = $(objdir)KVstore.o $(sitreeobj)  $(ivarrayobj) $(isarrayobj)

utilobj = $(objdir)Slog.o $(objdir)Util.o $(objdir)Bstr.o $(objdir)Stream.o $(objdir)Triple.o $(objdir)VList.o \
			$(objdir)EvalMultitypeValue.o $(objdir)IDTriple.o $(objdir)Version.o $(objdir)Transaction.o $(objdir)Latch.o $(objdir)IPWhiteList.o \
			$(objdir)IPBlackList.o  $(objdir)SpinLock.o $(objdir)GraphLock.o $(objdir)WebUrl.o $(objdir)INIParser.o $(objdir)OrderedVector.o \
			$(objdir)CompressFileUtil.o

topkobj = $(objdir)DynamicTrie.o $(objdir)OrderedList.o $(objdir)Pool.o $(objdir)TopKUtil.o $(objdir)DPBTopKUtil.o $(objdir)TopKSearchPlan.o

queryobj = $(objdir)SPARQLquery.o $(objdir)BasicQuery.o $(objdir)ResultSet.o  $(objdir)IDList.o $(objdir)DFSPlan.o\
		   $(objdir)Varset.o $(objdir)QueryTree.o $(objdir)TempResult.o $(objdir)QueryCache.o $(objdir)GeneralEvaluation.o \
		   $(objdir)PathQueryHandler.o $(objdir)BGPQuery.o $(objdir)FilterPlan.o

#signatureobj = $(objdir)SigEntry.o $(objdir)Signature.o

#vstreeobj = $(objdir)VSTree.o $(objdir)EntryBuffer.o $(objdir)LRUCache.o $(objdir)VNode.o

stringindexobj = $(objdir)StringIndex.o

parserobj = $(objdir)RDFParser.o $(objdir)SPARQLParser.o \
			$(objdir)SPARQLLexer.o $(objdir)TurtleParser.o $(objdir)QueryParser.o

serverobj = $(objdir)Operation.o $(objdir)Server.o $(objdir)Socket.o

grpcobj = $(objdir)grpc_server.o $(objdir)grpc_server_task.o $(objdir)grpc_message.o \
		  $(objdir)grpc_router.o $(objdir)grpc_routetable.o $(objdir)grpc_content.o \
		  $(objdir)grpc_status_code.o $(objdir)grpc_multipart_parser.o ${objdir}APIUtil.o

databaseobj =  $(objdir)Database.o $(objdir)Join.o \
			   $(objdir)CSR.o $(objdir)Txn_manager.o $(objdir)TableOperator.o $(objdir)PlanTree.o  \
			   $(objdir)PlanGenerator.o $(objdir)Executor.o $(objdir)Optimizer.o

trieobj = $(objdir)Trie.o $(objdir)TrieNode.o

objfile = $(kvstoreobj) $(stringindexobj) $(parserobj) $(serverobj) $(databaseobj) \
		  $(utilobj) $(topkobj) $(queryobj) $(trieobj)
	 
inc = -I./tools/antlr4-cpp-runtime-4/runtime/src
inc_rpc = -I./tools/workflow/_include
inc_log = -I./tools/log4cplus/include
inc_zlib= -I./tools/zlib-1.3/include
#auto generate dependencies
# http://blog.csdn.net/gmpy_tiger/article/details/51849474
# http://blog.csdn.net/jeffrey0000/article/details/12421317

#gtest

TARGET = $(exedir)gexport $(exedir)gbuild $(exedir)gserver $(exedir)gserver_backup_scheduler \
		 $(exedir)gquery  $(exedir)gadd $(exedir)gsub $(exedir)ghttp  $(exedir)gmonitor \
		 $(exedir)gshow $(exedir)shutdown $(exedir)ginit $(exedir)gdrop  $(exedir)gbackup \
		 $(exedir)grestore $(exedir)gpara $(exedir)rollback $(exedir)grpc $(exedir)gconsole
# TestTarget = $(testdir)update_test $(testdir)dataset_test $(testdir)transaction_test \
			 $(testdir)run_transaction $(testdir)workload $(testdir)debug_test
# TARGET = $(exedir)gbuild $(exedir)gdrop $(exedir)gquery $(exedir)ginit

all: $(TARGET)
	@echo "Compilation ends successfully!"
	@bash scripts/init.sh

#BETTER: use for loop to reduce the lines
#NOTICE: g++ -MM will run error if linking failed, like Database.h/../SparlParser.h/../antlr3.h

#executables begin

#NOTICE:not include g*.o in objfile due to multiple definitions of main()

$(exedir)gexport: $(lib_antlr) $(objdir)gexport.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gexport $(objdir)gexport.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)gdrop: $(lib_antlr) $(objdir)gdrop.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gdrop $(objdir)gdrop.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)ginit: $(lib_antlr) $(objdir)ginit.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)ginit $(objdir)ginit.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)shutdown: $(lib_antlr) $(objdir)shutdown.o $(objfile) $(api_cpp)
	$(CXX) $(EXEFLAG) -o $(exedir)shutdown $(objdir)shutdown.o $(objfile) $(openmp) -L./api/http/cpp/lib -lgstoreconnector $(library) ${ldl}

$(exedir)gmonitor: $(lib_antlr) $(objdir)gmonitor.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gmonitor $(objdir)gmonitor.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)gshow: $(lib_antlr) $(objdir)gshow.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gshow $(objdir)gshow.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)gbuild: $(lib_antlr) $(objdir)gbuild.o $(objfile) 
	$(CXX) $(EXEFLAG) -o $(exedir)gbuild $(objdir)gbuild.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)gquery: $(lib_antlr) $(objdir)gquery.o $(objfile) 
	$(CXX) $(EXEFLAG) -o $(exedir)gquery $(objdir)gquery.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)gserver: $(lib_antlr) $(objdir)gserver.o $(objfile) 
	$(CXX) $(EXEFLAG) -o $(exedir)gserver $(objdir)gserver.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)gserver_backup_scheduler: $(lib_antlr) $(objdir)gserver_backup_scheduler.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gserver_backup_scheduler $(objdir)gserver_backup_scheduler.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)ghttp: $(lib_antlr) $(objdir)ghttp.o src/Server src/Server src/Server $(objfile) ${objdir}APIUtil.o
	$(CXX) $(EXEFLAG) -o $(exedir)ghttp $(objdir)ghttp.o $(objfile) ${objdir}APIUtil.o $(library) $(inc) $(openmp) ${ldl}

#$(exedir)gapiserver: $(lib_antlr) $(lib_workflow) $(objdir)gapiserver.o  $(objfile)
#	$(CXX) $(EXEFLAG) -o $(exedir)gapiserver $(objdir)gapiserver.o $(objfile) $(library) $(openmp)

$(exedir)grpc: $(lib_antlr) $(lib_rpc) $(objdir)grpc.o $(grpcobj) $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)grpc $(objdir)grpc.o ${grpcobj} $(objfile) $(library) $(inc) ${inc_rpc} -lworkflow -lssl -lcrypto $(openmp) ${ldl}

$(exedir)gbackup: $(lib_antlr) $(objdir)gbackup.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gbackup $(objdir)gbackup.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)grestore: $(lib_antlr) $(objdir)grestore.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)grestore $(objdir)grestore.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)gpara: $(lib_antlr) $(objdir)gpara.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gpara $(objdir)gpara.o $(objfile) $(library) $(openmp) -L./api/http/cpp/lib -lgstoreconnector $(library) ${ldl}

$(exedir)rollback: $(lib_antlr) $(objdir)rollback.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)rollback $(objdir)rollback.o $(objfile) $(library) $(openmp) -L./api/http/cpp/lib -lgstoreconnector $(library) ${ldl}

$(testdir)update_test: $(lib_antlr) $(objdir)update_test.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(testdir)update_test $(objdir)update_test.o $(objfile) $(library) $(openmp) ${ldl}

$(testdir)dataset_test: $(lib_antlr) $(objdir)dataset_test.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(testdir)dataset_test $(objdir)dataset_test.o $(objfile) $(library) $(openmp) ${ldl}

$(testdir)transaction_test: $(lib_antlr) $(objdir)transaction_test.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(testdir)transaction_test $(objdir)transaction_test.o $(objfile) $(library) $(openmp) ${ldl}

$(testdir)run_transaction: $(lib_antlr) $(objdir)run_transaction.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(testdir)run_transaction $(objdir)run_transaction.o $(objfile) $(library) $(openmp) -L./api/http/cpp/lib -lgstoreconnector $(library) ${ldl}

$(testdir)workload: $(lib_antlr) $(objdir)workload.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(testdir)workload $(objdir)workload.o $(objfile) $(library) $(openmp) ${ldl}

$(testdir)debug_test: $(lib_antlr) $(objdir)debug_test.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(testdir)debug_test $(objdir)debug_test.o $(objfile) $(library) $(openmp) ${ldl}

$(exedir)gconsole: $(lib_antlr) $(objdir)gconsole.o $(objfile) 
	$(CXX) $(EXEFLAG) -o $(exedir)gconsole $(objdir)gconsole.o $(objfile) $(library) $(openmp) ${ldl}

#executables end


#objects in Main/ begin

$(objdir)gexport.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gexport.cpp $(inc) $(inc_log) -o $(objdir)gexport.o $(openmp)

$(objdir)gdrop.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gdrop.cpp $(inc) $(inc_log) -o $(objdir)gdrop.o $(openmp)

$(objdir)ginit.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/ginit.cpp $(inc) $(inc_log) -o $(objdir)ginit.o $(openmp)

$(objdir)shutdown.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/shutdown.cpp $(inc) $(inc_log) -o $(objdir)shutdown.o $(openmp)

$(objdir)gmonitor.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gmonitor.cpp $(inc) $(inc_log) -o $(objdir)gmonitor.o $(openmp)

$(objdir)gshow.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gshow.cpp $(inc) $(inc_log) -o $(objdir)gshow.o $(openmp)

$(objdir)gbuild.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gbuild.cpp $(inc) $(inc_log) -o $(objdir)gbuild.o $(openmp)
	
$(objdir)gquery.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gquery.cpp $(inc) $(inc_log) -o $(objdir)gquery.o $(openmp) #-DREADLINE_ON
	#add -DREADLINE_ON if using readline

$(objdir)gserver.o: src/Main src/Server src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gserver.cpp $(inc) $(inc_log) -o $(objdir)gserver.o $(openmp)

$(objdir)gserver_backup_scheduler.o: src/Main src/Server src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gserver_backup_scheduler.cpp $(inc) $(inc_log) -o $(objdir)gserver_backup_scheduler.o $(openmp)

$(objdir)ghttp.o: src/Main src/Server src/Server src/Server src/Database src/Database src/Util src/Util src/Util src/Util $(lib_antlr) src/Util src/Util src/GRPC
	$(CXX) $(CFLAGS) Main/ghttp.cpp $(inc) $(inc_log) $(inc_zlib) -o $(objdir)ghttp.o $(def64IO) $(openmp)

#$(objdir)gapiserver.o: Main/gapiserver.cpp Database/Database.h Database/Txn_manager.h Util/Util.h Util/Util_New.h Util/IPWhiteList.h Util/IPBlackList.h Util/WebUrl.h  $(lib_antlr) $(lib_workflow)
#	$(CXX) $(CFLAGS) Main/gapiserver.cpp $(inc) $(inc_workflow) -o $(objdir)gapiserver.o $(openmp)

$(objdir)grpc.o: src/Main src/GRPC src/GRPC src/GRPC src/GRPC src/Util src/Database src/Database src/Util $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) Main/grpc.cpp $(inc) $(inc_log) $(inc_rpc) $(inc_zlib) -o $(objdir)grpc.o $(def64IO) $(openmp)

$(objdir)gbackup.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gbackup.cpp $(inc) $(inc_log) -o $(objdir)gbackup.o $(openmp)

$(objdir)grestore.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/grestore.cpp $(inc) $(inc_log) -o $(objdir)grestore.o $(openmp)

$(objdir)gpara.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gpara.cpp $(inc) $(inc_log) -o $(objdir)gpara.o $(openmp)

$(objdir)rollback.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/rollback.cpp $(inc) $(inc_log) -o $(objdir)rollback.o $(openmp)

$(objdir)gconsole.o: src/Main src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) Main/gconsole.cpp $(inc) $(inc_log) -o $(objdir)gconsole.o $(openmp)
#objects in Main/ end

#objects in tests/ begin

$(objdir)update_test.o: $(testdir)update_test.cpp Database/Database.h Util/Util.h $(lib_antlr)
	$(CXX) $(CFLAGS) $(testdir)update_test.cpp $(inc) $(inc_log) -o $(objdir)update_test.o $(openmp)

$(objdir)dataset_test.o: $(testdir)dataset_test.cpp Database/Database.h Util/Util.h $(lib_antlr)
	$(CXX) $(CFLAGS) $(testdir)dataset_test.cpp $(inc) $(inc_log) -o $(objdir)dataset_test.o $(openmp)

$(objdir)transaction_test.o: $(testdir)transaction_test.cpp Database/Database.h Database/Txn_manager.h Util/Util.h $(lib_antlr)
	$(CXX) $(CFLAGS) $(testdir)transaction_test.cpp $(inc) $(inc_log) -o $(objdir)transaction_test.o $(openmp)

$(objdir)run_transaction.o: $(testdir)run_transaction.cpp src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) $(testdir)run_transaction.cpp $(inc) $(inc_log) -o $(objdir)run_transaction.o $(openmp)

$(objdir)workload.o: $(testdir)workload.cpp Util/Util.h $(lib_antlr)
	$(CXX) $(CFLAGS) $(testdir)workload.cpp $(inc) $(inc_log) -o $(objdir)workload.o $(openmp)

$(objdir)debug_test.o: $(testdir)debug_test.cpp Util/Util.h $(lib_antlr)
	$(CXX) $(CFLAGS) $(testdir)debug_test.cpp $(inc) $(inc_log) -o $(objdir)debug_test.o $(openmp)

#objects in tests/ end


#objects in kvstore/ begin

#objects in sitree/ begin
$(objdir)SITree.o: src/KVstore src/KVstore $(filter $(FIRST_BUILD),$(objdir)Stream.o)
	@echo $(FAST_DEPENDENCY_FLAG)
	$(CXX) $(CFLAGS) KVstore/SITree/SITree.cpp $(inc_log) -o $(objdir)SITree.o $(openmp)

$(objdir)SIStorage.o: src/KVstore src/KVstore $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS) KVstore/SITree/storage/SIStorage.cpp $(inc_log) -o $(objdir)SIStorage.o $(def64IO) $(openmp)

$(objdir)SINode.o: src/KVstore src/KVstore $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS) KVstore/SITree/node/SINode.cpp $(inc_log) -o $(objdir)SINode.o $(openmp)

$(objdir)SIIntlNode.o: src/KVstore src/KVstore
	$(CXX) $(CFLAGS) KVstore/ $(inc_log) -o $(objdir)SIIntlNode.o $(openmp)

$(objdir)SILeafNode.o: src/KVstore src/KVstore
	$(CXX) $(CFLAGS) KVstore/SITree/node/SILeafNode.cpp $(inc_log) -o $(objdir)SILeafNode.o $(openmp)

$(objdir)SIHeap.o: src/KVstore src/KVstore $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS) KVstore/SITree/heap/SIHeap.cpp $(inc_log) -o $(objdir)SIHeap.o $(openmp)
#objects in sitree/ end

#objects in isarray/ begin
$(objdir)ISArray.o: src/KVstore src/KVstore $(filter $(FIRST_BUILD),$(objdir)VList.o)
	$(CXX) $(CFLAGS) KVstore/ISArray/ISArray.cpp $(inc_log) -o $(objdir)ISArray.o

$(objdir)ISBlockManager.o: src/KVstore src/KVstore
	$(CXX) $(CFLAGS) KVstore/ISArray/ISBlockManager.cpp $(inc_log) -o $(objdir)ISBlockManager.o

$(objdir)ISEntry.o: src/KVstore src/KVstore
	$(CXX) $(CFLAGS) KVstore/ISArray/ISEntry.cpp $(inc_log) -o $(objdir)ISEntry.o
#objects in isarray/ end

#objects in ivarray/ begin
$(objdir)IVArray.o: src/KVstore src/KVstore $(filter $(FIRST_BUILD),$(objdir)VList.o) \
	$(filter $(FIRST_BUILD),$(objdir)Transaction.o)
	$(CXX) $(CFLAGS) KVstore/IVArray/IVArray.cpp $(inc_log) -o $(objdir)IVArray.o

$(objdir)IVBlockManager.o: src/KVstore src/KVstore
	$(CXX) $(CFLAGS) KVstore/IVArray/IVBlockManager.cpp $(inc_log) -o $(objdir)IVBlockManager.o

$(objdir)IVEntry.o: src/KVstore src/KVstore $(filter $(FIRST_BUILD),$(objdir)Version.o) \
	$(filter $(FIRST_BUILD),$(objdir)GraphLock.o)
	$(CXX) $(CFLAGS) KVstore/IVArray/IVEntry.cpp $(inc_log) -o $(objdir)IVEntry.o

#objects in ivarray/ end

$(objdir)KVstore.o: src/KVstore src/KVstore src/KVstore
	$(CXX) $(CFLAGS) KVstore/KVstore.cpp $(inc) $(inc_log) -o $(objdir)KVstore.o $(openmp)

#objects in kvstore/ end


#objects in Database/ begin


$(objdir)Database.o: src/Database src/Database $(filter $(FIRST_BUILD),$(objdir)RDFParser.o) \
	$(filter $(FIRST_BUILD),$(objdir)GeneralEvaluation.o) $(filter $(FIRST_BUILD),$(objdir)StringIndex.o) \
	$(filter $(FIRST_BUILD),$(objdir)Transaction.o)
	$(CXX) $(CFLAGS) Database/Database.cpp $(inc) $(inc_log) -o $(objdir)Database.o $(openmp)

$(objdir)Join.o: src/Database src/Database $(filter $(FIRST_BUILD),$(objdir)IDList.o) \
	$(filter $(FIRST_BUILD),$(objdir)KVstore.o) $(filter $(FIRST_BUILD),$(objdir)SPARQLquery.o)  $(filter $(FIRST_BUILD),$(objdir)Transaction.o)
	$(CXX) $(CFLAGS) Database/Join.cpp $(inc) $(inc_log) -o $(objdir)Join.o $(openmp)

$(objdir)CSR.o: src/Database src/Database
	$(CXX) $(CFLAGS) Database/CSR.cpp $(inc) -o $(objdir)CSR.o $(openmp)
	$(CXX) -std=c++11 -fPIC -shared Database/CSR.cpp -o lib/libgcsr.so

$(objdir)TableOperator.o: src/Database src/Database $(filter $(FIRST_BUILD),$(objdir)BGPQuery.o)
	$(CXX) $(CFLAGS) Database/TableOperator.cpp $(inc) $(inc_log) -o $(objdir)TableOperator.o $(openmp)

#$(objdir)ResultTrigger.o: Database/ResultTrigger.cpp Database/ResultTrigger.h $(objdir)Util.o
#	$(CXX) $(CFLAGS) Database/ResultTrigger.cpp $(inc) -o $(objdir)ResultTrigger.o $(openmp)

$(objdir)PlanTree.o: src/Database src/Database $(filter $(FIRST_BUILD),$(objdir)TableOperator.o)
	$(CXX) $(CFLAGS) Database/PlanTree.cpp $(inc) $(inc_log) -o $(objdir)PlanTree.o  $(openmp)

$(objdir)PlanGenerator.o: src/Database src/Database \
	$(filter $(FIRST_BUILD),$(objdir)IDList.o) $(filter $(FIRST_BUILD),$(objdir)PlanTree.o) \
	 $(filter $(FIRST_BUILD),$(objdir)OrderedVector.o)
	$(CXX) $(CFLAGS) Database/PlanGenerator.cpp $(inc) $(inc_log) -o $(objdir)PlanGenerator.o $(openmp)

$(objdir)Executor.o: src/Database src/Database $(filter $(FIRST_BUILD),$(objdir)IDList.o) \
	$(filter $(FIRST_BUILD),$(objdir)Join.o) $(filter $(FIRST_BUILD),$(objdir)Transaction.o)  \
	$(filter $(FIRST_BUILD),$(objdir)TableOperator.o) $(filter $(FIRST_BUILD), $(objdir)DPBTopKUtil.o)
	$(CXX) $(CFLAGS) Database/Executor.cpp $(inc) $(inc_log) -o $(objdir)Executor.o $(openmp) ${ldl}

$(objdir)Optimizer.o: src/Database src/Database src/Database \
	$(filter $(FIRST_BUILD), $(objdir)Executor.o) $(filter $(FIRST_BUILD),$(objdir)DFSPlan.o) \
	$(filter $(FIRST_BUILD),$(objdir)PlanGenerator.o) $(filter $(FIRST_BUILD),$(objdir)DPBTopKUtil.o) \
	$(filter $(FIRST_BUILD),$(objdir)FilterPlan.o)
	$(CXX) $(CFLAGS) Database/Optimizer.cpp $(inc) $(inc_log) -o $(objdir)Optimizer.o $(openmp) ${ldl}

$(objdir)Txn_manager.o: src/Database src/Database $(filter $(FIRST_BUILD),$(objdir)Util.o) \
	$(filter $(FIRST_BUILD),$(objdir)Transaction.o) $(filter $(FIRST_BUILD),$(objdir)Database.o)
	$(CXX) $(CFLAGS) Database/Txn_manager.cpp $(inc) $(inc_log) -o $(objdir)Txn_manager.o $(openmp)

#objects in Database/ end


#objects in Query/ begin

$(objdir)IDList.o: src/Query src/Query
	$(CXX) $(CFLAGS) Query/IDList.cpp $(inc) $(inc_log) -o $(objdir)IDList.o $(openmp)

$(objdir)SPARQLquery.o: src/Query src/Query $(filter $(FIRST_BUILD),$(objdir)BasicQuery.o)
	$(CXX) $(CFLAGS) Query/SPARQLquery.cpp $(inc) $(inc_log) -o $(objdir)SPARQLquery.o $(openmp)

$(objdir)BasicQuery.o: src/Query src/Query
	$(CXX) $(CFLAGS) Query/BasicQuery.cpp $(inc) $(inc_log) -o $(objdir)BasicQuery.o $(openmp)

$(objdir)ResultSet.o: src/Query src/Query $(filter $(FIRST_BUILD),$(objdir)Stream.o)
	$(CXX) $(CFLAGS) Query/ResultSet.cpp $(inc) $(inc_log) -o $(objdir)ResultSet.o $(openmp)

$(objdir)Varset.o: src/Query src/Query
	$(CXX) $(CFLAGS) Query/Varset.cpp $(inc) $(inc_log) -o $(objdir)Varset.o $(openmp)

$(objdir)DFSPlan.o: src/Query src/Query  $(filter $(FIRST_BUILD),$(objdir)TableOperator.o)
	$(CXX) $(CFLAGS) Query/DFSPlan.cpp $(inc) $(inc_log) -o $(objdir)DFSPlan.o $(openmp)

$(objdir)QueryTree.o: src/Query src/Query $(filter $(FIRST_BUILD),$(objdir)Varset.o)
	$(CXX) $(CFLAGS) Query/QueryTree.cpp $(inc) $(inc_log) -o $(objdir)QueryTree.o $(openmp)

$(objdir)TempResult.o: src/Query src/Query src/Query \
	$(filter $(FIRST_BUILD),$(objdir)StringIndex.o) $(filter $(FIRST_BUILD),$(objdir)QueryTree.o) \
	$(filter $(FIRST_BUILD),$(objdir)EvalMultitypeValue.o)
	$(CXX) $(CFLAGS) Query/TempResult.cpp $(inc) $(inc_log) -o $(objdir)TempResult.o $(openmp)

$(objdir)QueryCache.o: src/Query src/Query $(filter $(FIRST_BUILD),$(objdir)TempResult.o)
	$(CXX) $(CFLAGS) Query/QueryCache.cpp $(inc) $(inc_log) -o $(objdir)QueryCache.o $(openmp)

$(objdir)PathQueryHandler.o: src/Query src/Query $(filter $(FIRST_BUILD),$(objdir)CSR.o)
	$(CXX) $(CFLAGS) Query/PathQueryHandler.cpp $(inc) -o $(objdir)PathQueryHandler.o $(openmp) ${ldl}
	$(CXX) -std=c++11 -fPIC -shared Query/PathQueryHandler.cpp -o lib/libgpathqueryhandler.so lib/libgcsr.so

$(objdir)BGPQuery.o: src/Query src/Query   $(filter $(FIRST_BUILD),$(objdir)Util.o) \
 	$(filter $(FIRST_BUILD),$(objdir)Triple.o)  $(filter $(FIRST_BUILD),$(objdir)KVstore.o)
	$(CXX) $(CFLAGS) Query/BGPQuery.cpp $(inc) $(inc_log) -o $(objdir)BGPQuery.o $(openmp)

$(objdir)FilterPlan.o: src/Query src/Query  $(filter $(FIRST_BUILD),$(objdir)TableOperator.o)
	$(CXX) $(CFLAGS) Query/FilterPlan.cpp $(inc) $(inc_log) -o $(objdir)FilterPlan.o $(openmp)

#objects in Query/topk/ begin

$(objdir)Pool.o: src/Query src/Query $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS) Query/topk/DPB/Pool.cpp $(inc) $(inc_log) -o $(objdir)Pool.o $(openmp)

$(objdir)DynamicTrie.o: src/Query src/Query \
	$(filter $(FIRST_BUILD),$(objdir)Util.o) $(filter $(FIRST_BUILD),$(objdir)Pool.o)
	$(CXX) $(CFLAGS) Query/topk/DPB/DynamicTrie.cpp $(inc) $(inc_log) -o $(objdir)DynamicTrie.o $(openmp)

$(objdir)OrderedList.o: src/Query src/Query \
	$(filter $(FIRST_BUILD),$(objdir)Util.o) $(filter $(FIRST_BUILD),$(objdir)Pool.o) \
	$(filter $(FIRST_BUILD),$(objdir)DynamicTrie.o)
	$(CXX) $(CFLAGS) Query/topk/DPB/OrderedList.cpp $(inc) $(inc_log) -o $(objdir)OrderedList.o $(openmp)

$(objdir)TopKSearchPlan.o: src/Query src/Query \
	$(filter $(FIRST_BUILD),$(objdir)OrderedList.o) $(filter $(FIRST_BUILD),$(objdir)QueryTree.o) $(filter $(FIRST_BUILD),$(objdir)PlanGenerator.o)
	$(CXX) $(CFLAGS) Query/topk/TopKSearchPlan.cpp $(inc) $(inc_log) -o $(objdir)TopKSearchPlan.o $(openmp)

$(objdir)TopKUtil.o: src/Query src/Query $(filter $(FIRST_BUILD),$(objdir)TopKSearchPlan.o)
	$(CXX) $(CFLAGS) Query/topk/TopKUtil.cpp $(inc) $(inc_log) -o $(objdir)TopKUtil.o $(openmp)

$(objdir)DPBTopKUtil.o: src/Query src/Query $(filter $(FIRST_BUILD),$(objdir)TopKUtil.o)
	$(CXX) $(CFLAGS) Query/topk/DPBTopKUtil.cpp $(inc) $(inc_log) -o $(objdir)DPBTopKUtil.o $(openmp)

#objects in Query/topk/ end


#no more using $(objdir)Database.o
$(objdir)GeneralEvaluation.o: src/Query src/Query src/Query \
	$(filter $(FIRST_BUILD),$(objdir)StringIndex.o) $(filter $(FIRST_BUILD),$(objdir)QueryParser.o) \
	$(filter $(FIRST_BUILD),$(objdir)EvalMultitypeValue.o) $(filter $(FIRST_BUILD),$(objdir)SPARQLquery.o) \
	$(filter $(FIRST_BUILD),$(objdir)QueryCache.o) $(filter $(FIRST_BUILD),$(objdir)ResultSet.o) \
	$(filter $(FIRST_BUILD),$(objdir)PathQueryHandler.o) $(filter $(FIRST_BUILD),$(objdir)Optimizer.o)
	$(CXX) $(CFLAGS) Query/GeneralEvaluation.cpp $(inc) $(inc_log) -o $(objdir)GeneralEvaluation.o $(openmp) ${ldl}

#objects in Query/ end


#objects in Signature/ begin

#$(objdir)SigEntry.o: Signature/SigEntry.cpp Signature/SigEntry.h $(objdir)Signature.o
#	$(CXX) $(CFLAGS) Signature/SigEntry.cpp $(inc) -o $(objdir)SigEntry.o $(openmp)
#
#$(objdir)Signature.o: Signature/Signature.cpp Signature/Signature.h
#	$(CXX) $(CFLAGS) Signature/Signature.cpp $(inc) -o $(objdir)Signature.o $(openmp)

#objects in Signature/ end


#objects in Util/ begin

$(objdir)Util.o:  src/Util src/Util $(objdir)Slog.o
	$(CXX) $(CFLAGS) Util/Util.cpp $(inc_log) -o $(objdir)Util.o $(openmp)

$(objdir)WebUrl.o:  src/Util src/Util
	$(CXX) $(CFLAGS) Util/WebUrl.cpp -o $(objdir)WebUrl.o $(openmp)



$(objdir)INIParser.o:  src/Util src/Util
	$(CXX) $(CFLAGS) Util/INIParser.cpp -o $(objdir)INIParser.o $(openmp)

$(objdir)Slog.o:  src/Util src/Util $(lib_log)
	$(CXX) $(CFLAGS) Util/Slog.cpp $(inc_log) -o $(objdir)Slog.o $(openmp)

#$(objdir)grpc.srpc.o:   GRPC/grpc.srpc.h $(lib_workflow)
#	$(CXX) $(CFLAGS)  GRPC/grpc.srpc.h -o $(objdir)grpc.srpc.o $(openmp)

$(objdir)Stream.o:  src/Util src/Util $(filter $(FIRST_BUILD),$(objdir)Util.o) $(filter $(FIRST_BUILD),$(objdir)Bstr.o)
	$(CXX) $(CFLAGS) Util/Stream.cpp $(inc_log) -o $(objdir)Stream.o $(def64IO) $(openmp)

$(objdir)Bstr.o: src/Util src/Util $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS)  Util/Bstr.cpp $(inc_log) -o $(objdir)Bstr.o $(openmp)

$(objdir)Triple.o: src/Util src/Util $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS) Util/Triple.cpp $(inc_log) -o $(objdir)Triple.o $(openmp)

$(objdir)VList.o:  src/Util src/Util
	$(CXX) $(CFLAGS) Util/VList.cpp $(inc_log) -o $(objdir)VList.o $(openmp)

$(objdir)EvalMultitypeValue.o: src/Util src/Util
	$(CXX) $(CFLAGS) Util/EvalMultitypeValue.cpp $(inc_log) -o $(objdir)EvalMultitypeValue.o $(openmp)

$(objdir)Version.o: src/Util src/Util
	$(CXX) $(CFLAGS) Util/Version.cpp $(inc_log) -o $(objdir)Version.o $(openmp)

$(objdir)SpinLock.o: src/Util src/Util
	$(CXX) $(CFLAGS) Util/SpinLock.cpp -o $(objdir)SpinLock.o $(openmp)

$(objdir)GraphLock.o: src/Util src/Util
	$(CXX) $(CFLAGS) Util/GraphLock.cpp -o $(objdir)GraphLock.o $(openmp)

$(objdir)Transaction.o: src/Util src/Util $(filter $(FIRST_BUILD),$(objdir)Util.o) $(filter $(FIRST_BUILD),$(objdir)IDTriple.o)
	$(CXX) $(CFLAGS) Util/Transaction.cpp $(inc) $(inc_log) -o $(objdir)Transaction.o $(openmp)

$(objdir)IDTriple.o: src/Util src/Util
	$(CXX) $(CFLAGS) Util/IDTriple.cpp $(inc_log) -o $(objdir)IDTriple.o $(openmp)

$(objdir)Latch.o: src/Util src/Util
	$(CXX) $(CFLAGS) Util/Latch.cpp -o $(objdir)Latch.o $(openmp)

$(objdir)IPWhiteList.o:  src/Util src/Util $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS) Util/IPWhiteList.cpp $(inc_log) -o $(objdir)IPWhiteList.o $(def64IO) $(openmp)

$(objdir)IPBlackList.o:  src/Util src/Util $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS) Util/IPBlackList.cpp $(inc_log) -o $(objdir)IPBlackList.o $(def64IO) $(openmp)

$(objdir)OrderedVector.o: src/Util src/Util
	$(CXX) $(CFLAGS) Util/OrderedVector.cpp -o $(objdir)OrderedVector.o $(openmp)

#objects in util/ end


#objects in VSTree/ begin

#$(objdir)VSTree.o: VSTree/VSTree.cpp VSTree/VSTree.h $(objdir)EntryBuffer.o $(objdir)LRUCache.o $(objdir)VNode.o
#	$(CXX) $(CFLAGS) VSTree/VSTree.cpp $(inc) -o $(objdir)VSTree.o $(def64IO) $(openmp)
#
#$(objdir)EntryBuffer.o: VSTree/EntryBuffer.cpp VSTree/EntryBuffer.h Signature/SigEntry.h
#	$(CXX) $(CFLAGS) VSTree/EntryBuffer.cpp $(inc) -o $(objdir)EntryBuffer.o $(def64IO) $(openmp)
#
#$(objdir)LRUCache.o: VSTree/LRUCache.cpp  VSTree/LRUCache.h VSTree/VNode.h
#	$(CXX) $(CFLAGS) VSTree/LRUCache.cpp $(inc) -o $(objdir)LRUCache.o $(def64IO) $(openmp)
#
#$(objdir)VNode.o: VSTree/VNode.cpp VSTree/VNode.h
#	$(CXX) $(CFLAGS) VSTree/VNode.cpp $(inc) -o $(objdir)VNode.o $(def64IO) $(openmp)

#objects in VSTree/ end


#objects in StringIndex/ begin
$(objdir)StringIndex.o: src/StringIndex src/StringIndex \
 	$(filter $(FIRST_BUILD),$(objdir)KVstore.o) $(filter $(FIRST_BUILD),$(objdir)Util.o)
	$(CXX) $(CFLAGS) StringIndex/StringIndex.cpp $(inc) $(inc_log) -o $(objdir)StringIndex.o $(def64IO) $(openmp)
#objects in StringIndex/ end


#objects in Parser/ begin

$(objdir)SPARQLParser.o: src/Parser src/Parser
	$(CXX)  $(CFLAGS) Parser/SPARQL/SPARQLParser.cpp $(inc) -o $(objdir)SPARQLParser.o $(openmp)

$(objdir)SPARQLLexer.o: src/Parser src/Parser
	$(CXX)  $(CFLAGS) Parser/SPARQL/SPARQLLexer.cpp $(inc) -o $(objdir)SPARQLLexer.o $(openmp)

$(objdir)TurtleParser.o: src/Parser src/Parser src/Parser
	$(CXX)  $(CFLAGS) Parser/TurtleParser.cpp $(inc) $(inc_log) -o $(objdir)TurtleParser.o $(openmp)

$(objdir)RDFParser.o: src/Parser src/Parser $(filter $(FIRST_BUILD),$(objdir)TurtleParser.o) $(filter $(FIRST_BUILD),$(objdir)Triple.o)
	$(CXX)  $(CFLAGS) Parser/RDFParser.cpp $(inc) $(inc_log) -o $(objdir)RDFParser.o $(openmp)

$(objdir)QueryParser.o: src/Parser src/Parser $(filter $(FIRST_BUILD),$(objdir)SPARQLParser.o) \
 	$(filter $(FIRST_BUILD),$(objdir)SPARQLLexer.o) $(filter $(FIRST_BUILD),$(objdir)QueryTree.o)
	$(CXX) $(CFLAGS) Parser/QueryParser.cpp $(inc) $(inc_log) -o $(objdir)QueryParser.o $(openmp)

#objects in Parser/ end

#objects in Trie/ begin

$(objdir)TrieNode.o: src/Trie src/Trie
	$(CXX) $(CFLAGS) Trie/TrieNode.cpp -o $(objdir)TrieNode.o

$(objdir)Trie.o: src/Trie src/Trie $(filter $(FIRST_BUILD),$(objdir)TrieNode.o) $(filter $(FIRST_BUILD),$(objdir)Triple.o) $(filter $(FIRST_BUILD),$(objdir)RDFParser.o)
	$(CXX) $(CFLAGS) Trie/Trie.cpp $(inc) $(inc_log) -o $(objdir)Trie.o

#objects in Server/ begin

$(objdir)Operation.o: src/Server src/Server
	$(CXX) $(CFLAGS) Server/Operation.cpp $(inc) $(inc_log) -o $(objdir)Operation.o $(openmp)

$(objdir)Socket.o: src/Server src/Server
	$(CXX) $(CFLAGS) Server/Socket.cpp $(inc) $(inc_log) -o $(objdir)Socket.o $(openmp)

$(objdir)Server.o: src/Server src/Server $(filter $(FIRST_BUILD),$(objdir)Socket.o) \
 	$(filter $(FIRST_BUILD),$(objdir)Database.o) $(filter $(FIRST_BUILD),$(objdir)Operation.o)
	$(CXX) $(CFLAGS) Server/Server.cpp $(inc) $(inc_log) -o $(objdir)Server.o $(openmp)

$(objdir)CompressFileUtil.o: src/Util src/Util src/Util
	$(CXX) $(CFLAGS)  Util/CompressFileUtil.cpp $(inc) $(inc_log) $(inc_zlib) -o $(objdir)CompressFileUtil.o $(def64IO) $(openmp)

# $(objdir)client_http.o: Server/client_http.hpp
# 	$(CXX) $(CFLAGS) Server/client_http.hpp $(inc) -o $(objdir)client_http.o

# $(objdir)server_http.o: Server/server_http.hpp
# 	$(CXX) $(CFLAGS) Server/server_http.hpp $(inc) -o $(objdir)server_http.o

#objects in Server/ end

#objects in GRPC/ begin

$(objdir)APIUtil.o: src/GRPC src/GRPC src/Database src/Database src/Util $(lib_antlr)
	$(CXX) $(CFLAGS) GRPC/APIUtil.cpp $(inc) $(inc_log) -o $(objdir)APIUtil.o $(def64IO) $(openmp)

$(objdir)grpc_status_code.o: src/GRPC src/GRPC $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) GRPC/grpc_status_code.cpp $(inc) $(inc_rpc) -o $(objdir)grpc_status_code.o $(def64IO) $(openmp)

$(objdir)grpc_multipart_parser.o: src/GRPC src/GRPC $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) GRPC/grpc_multipart_parser.cpp $(inc) $(inc_rpc) -o $(objdir)grpc_multipart_parser.o $(def64IO) $(openmp)

$(objdir)grpc_content.o: src/GRPC src/GRPC src/GRPC $(objdir)grpc_multipart_parser.o $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) GRPC/grpc_content.cpp $(inc) $(inc_rpc) -o $(objdir)grpc_content.o $(def64IO) $(openmp)

$(objdir)grpc_message.o: src/GRPC src/GRPC src/GRPC $(objdir)grpc_content.o $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) GRPC/grpc_message.cpp $(inc) $(inc_rpc) $(inc_log) -o $(objdir)grpc_message.o $(def64IO) $(openmp)

$(objdir)grpc_server_task.o: src/GRPC src/GRPC $(objdir)grpc_message.o src/GRPC $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) GRPC/grpc_server_task.cpp $(inc) $(inc_rpc) $(inc_log) -o $(objdir)grpc_server_task.o $(def64IO) $(openmp)

$(objdir)grpc_routetable.o: src/GRPC src/GRPC src/GRPC src/GRPC src/GRPC $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) GRPC/grpc_routetable.cpp $(inc) $(inc_rpc) $(inc_log) -o $(objdir)grpc_routetable.o $(def64IO) $(openmp)

$(objdir)grpc_router.o: src/GRPC src/GRPC $(objdir)grpc_routetable.o src/GRPC $(objdir)grpc_server_task.o $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) GRPC/grpc_router.cpp $(inc) $(inc_rpc) $(inc_log) -o $(objdir)grpc_router.o $(def64IO) $(openmp)

$(objdir)grpc_server.o: src/GRPC src/GRPC $(objdir)grpc_message.o $(objdir)grpc_router.o $(lib_antlr) $(lib_rpc)
	$(CXX) $(CFLAGS) GRPC/grpc_server.cpp $(inc) $(inc_rpc) $(inc_log) -o $(objdir)grpc_server.o $(def64IO) $(openmp)

#objects in GRPC/ end

# your gcc g++ v5.4 path
# in ./bashrc CXX should be gcc, otherwise, make pre2 will error
# see https://blog.csdn.net/weixin_34268610/article/details/89085852
#pre1:export CXX=/usr/local/gcc-5.4.0/bin/gcc
#pre1:export CXX=/usr/local/gcc-5.4.0/bin/g++
#pre1:
#	cd 3rdparty; tar -xvf log4cplus-1.2.0.tar;cd log4cplus-1.2.0;./configure;make;sudo make install;

pre:
	rm -rf tools/rapidjson/
	rm -rf tools/antlr4-cpp-runtime-4/
	rm -rf tools/workflow
	rm -rf tools/log4cplus
	rm -rf tools/indicators
	rm -rf tools/zlib-1.3
	rm -rf lib/libantlr4-runtime.a lib/libworkflow.a lib/liblog4cplus.a
	rm -rf lib/libminizip.a;
	cd tools; tar -xzvf rapidjson.tar.gz;
	cd tools; tar -xzvf antlr4-cpp-runtime-4.tar.gz;
	cd tools; tar -xvf indicators.tar;
	cd tools; tar -xzvf workflow-0.10.3.tar.gz;
	cd tools; tar -xzvf log4cplus-2.0.8.tar.gz;
	cd tools; tar -xzvf zlib-1.3.tar.gz;
	cd tools/antlr4-cpp-runtime-4/; cmake .; make; cp dist/libantlr4-runtime.a ../../lib/;
	cd tools/workflow; make; cp _lib/libworkflow.a ../../lib/;
	cd tools/log4cplus; ./configure --enable-static; make; cp .libs/liblog4cplus.a ../../lib/;
	cd tools/zlib-1.3; ./configure; make; cp *.h ./include/; cd contrib/minizip; make; cp *.h ../../include/; cp libminizip.a ../../../../lib/;

$(api_cpp): $(objdir)Socket.o
	$(MAKE) -C api/http/cpp/src

$(api_socket): $(objdir)Socket.o
	$(MAKE) -C api/socket/cpp/src


.PHONY: clean dist tarball api_example gtest sumlines contribution test

test: $(TARGET) $(testdir)update_test 
	@echo "basic build/query/add/sub/drop test......"
	@bash scripts/basic_test.sh
	@echo "repeatedly insertion/deletion test......"
	@scripts/update_test > /dev/null
	@echo "parser test......"
	@bash scripts/parser_test.sh

clean:
	#rm -rf lib/libantlr4-runtime.a
	$(MAKE) -C api/socket/cpp/src clean
	$(MAKE) -C api/socket/cpp/example clean
	$(MAKE) -C api/http/cpp/src clean
	$(MAKE) -C api/http/cpp/example clean
	$(MAKE) -C api/http/java/src clean
	$(MAKE) -C api/http/java/example clean
	#$(MAKE) -C KVstore clean
	rm -rf $(exedir)g* $(objdir)*.o $(exedir).gserver* $(exedir)shutdown $(exedir)rollback
	rm -rf bin/*.class
	rm -rf $(testdir)update_test $(testdir)dataset_test $(testdir)transaction_test $(testdir)run_transaction $(testdir)workload $(testdir)debug_test
	#rm -rf .project .cproject .settings   just for eclipse
	rm -rf logs/*.log
	rm -rf *.out   # gmon.out for gprof with -pg
	rm -rf lib/libgcsr.so lib/libgpathqueryhandler.so


dist: clean
	rm -rf *.nt *.n3 .debug/*.log .tmp/*.dat *.txt *.db
	rm -rf lib/libantlr4-runtime.a
	rm -rf cscope* .cproject .settings tags
	rm -rf *.info
	rm -rf backups/*.db

tarball:
	tar -czvf gstore.tar.gz api backups bin lib tools .debug .tmp .objs scripts data logs \
		Main Database KVstore Util Query Signature Parser Server StringIndex Trie GRPC COVERAGE \
		makefile init.conf conf.ini backup.json ipAllow.config ipDeny.config slog.properties slog.stdout.properties \
		README.md LICENSE
 
APIexample: $(api_cpp) $(api_socket) 
	$(MAKE) -C api/http/cpp/example
	$(MAKE) -C api/socket/cpp/example

gtest: $(objdir)gtest.o $(objfile) 
	$(CXX) $(EXEFLAG) -o $(exedir)gtest $(objdir)gtest.o $(objfile) $(library) $(openmp) ${ldl} 

$(objdir)gtest.o: scripts/gtest.cpp
	$(CXX) $(CFLAGS) scripts/gtest.cpp $(inc) $(inc_log) -o $(objdir)gtest.o $(openmp)
	
$(exedir)gadd: $(objdir)gadd.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gadd $(objdir)gadd.o $(objfile) lib/libantlr4-runtime.a $(library) $(openmp) ${ldl}

$(objdir)gadd.o: src/Main
	$(CXX) $(CFLAGS) Main/gadd.cpp $(inc) $(inc_log) -o $(objdir)gadd.o $(openmp)

#$(objdir)HttpConnector: $(objdir)HttpConnector.o $(objfile)
	#$(CXX) $(CFLAGS) -o $(exedir)HttpConnector $(objdir)HttpConnector.o $(objfile) lib/libantlr4-runtime.a $(library) $(inc)

#$(objdir)HttpConnector.o: Main/HttpConnector.cpp
	#$(CXX) $(CFLAGS) Main/HttpConnector.cpp $(inc) -o $(objdir)HttpConnector.o $(library)

$(exedir)gsub: $(objdir)gsub.o $(objfile)
	$(CXX) $(EXEFLAG) -o $(exedir)gsub $(objdir)gsub.o $(objfile) lib/libantlr4-runtime.a $(library) $(openmp) ${ldl}

$(objdir)gsub.o: src/Main
	$(CXX) $(CFLAGS) Main/gsub.cpp $(inc) $(inc_log) -o $(objdir)gsub.o $(openmp)

sumlines:
	@bash scripts/sumline.sh

tag:
	ctags -R

idx:
	find `realpath .` -name "*.h" -o -name "*.c" -o -name "*.cpp" > cscope.files
	cscope -bkq #-i cscope.files

cover:
	bash scripts/cover.sh

fulltest:
	#NOTICE:compile gstore with -O2 only
	#setup new virtuoso and configure it
	cp scripts/full_test.sh ~
	cd ~
	bash full_test.sh

#test the efficience of kvstore, insert/delete/search, use dbpedia170M by default
test-kvstore:
	# test/kvstore_test.cpp
	echo "TODO"

# https://segmentfault.com/a/1190000008542123
contribution:
	bash scripts/contribution.sh

