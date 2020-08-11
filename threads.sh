if [ $# -eq 0 ]; then
    echo "count threads"
    ps -eo nlwp | tail -n +2 | awk '{ num_threads += $1 } END { print num_threads }'
else
    pid=$(ps aux | ag $1 | awk '{print $2}' | head -n 1)
    ps -o nlwp $pid
fi
