# -----------------------------------
# 1. 定义变量
# -----------------------------------
CM_OPT = -cm line+cond+fsm+tgl+branch -cm_dir ./cov.vdb
all: vcs run
# -----------------------------------
# 2. 编译 (Comp)  
# -----------------------------------
vcs:
	vcs \
	-f filelist.f \
	+incdir+../tb \
	-timescale=1ns/1ps \
	-ntb_opts uvm-1.2 \
	-full64 +vc +v2k -sverilog \
	$(CM_OPT) \
	-debug_access+all \
	-kdb \
	-l comp.log

# -----------------------------------
# 3. 仿真 (Run)
# -----------------------------------
SEED = random
run:
	./simv \
	$(CM_OPT) \
	+ntb_random_seed=$(SEED) \
	-l run_seed_$(SEED).log

# -----------------------------------
# 4. Verdi 
# -----------------------------------
verdi:
	verdi \
	-sv -f filelist.f \
	-ssf tb.fsdb \
	-cov -covdir ./cov.vdb &

# -----------------------------------
# 5. 清理
# -----------------------------------
clean:
	rm -rf *~ core csrc simv* vc_hdrs.h ucli.key urg* *.log novas.* *.fsdb* verdiLog 64* DVEfiles *.vpd *.vdb vdCovLog
