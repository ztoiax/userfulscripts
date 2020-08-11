if [ $# -eq 0 ]; then
    read -p "enter process: " process
    ps aux | ag $process | awk '{print $2}' | head -n 1 | xargs kill -9
else
    ps aux | ag $1 | awk '{print $2}' | head -n 1 | xargs kill -9
fi
