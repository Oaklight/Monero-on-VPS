until ~/Monero-on-VPS/xmrig/xmrig; do
    echo "Xmrig crashed with exit code $?. Respawning.." >&2
    sleep 1
done
