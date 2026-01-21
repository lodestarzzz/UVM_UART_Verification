#!/bin/bash

# 清理旧数据
make clean
make vcs

# 循环跑 10 次
for i in {1..10}
do
    echo "Running test $i with random seed..."
    # 每次跑都用 random 种子，并且把 Log 存下来
    ./simv -cm line+cond+fsm+tgl+branch -cm_dir ./cov.vdb +ntb_random_seed=random -l run_$i.log > /dev/null
    
    # 简单的检查：如果 Log 里有 UVM_ERROR，就报警
    if grep -q "UVM_ERROR :    0" run_$i.log; then
        echo "Test $i PASS ✅"
    else
        echo "Test $i FAIL ❌ (Check run_$i.log)"
    fi
done

echo "Regression Done! Merging coverage..."
# 最后可以用 Verdi 打开 cov.vdb，它会自动合并这 10 次的覆盖率
