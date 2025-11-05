
# export AITER_ENABLE_VSKIP=0 

# export VLLM_ROCM_USE_AITER=1
# # export VLLM_ROCM_USE_AITER_MLA=1
# # export VLLM_ROCM_USE_AITER_MOE=1
# export VLLM_LOGGING_LEVEL=INFO
# export VLLM_USE_V1=1




pkill -9 vllm
export VLLM_ALL2ALL_BACKEND=mori 
export VLLM_USE_V1=1    
export VLLM_ROCM_USE_AITER=1 
export VLLM_ROCM_USE_AITER_LINEAR=1 
export VLLM_ROCM_USE_AITER_MLA=0
export VLLM_ROCM_USE_AITER_MOE=1 
export VLLM_ROCM_USE_AITER_RMSNORM=1 
export VLLM_ROCM_USE_AITER_FUSION_SHARED_EXPERTS=0 
export VLLM_ROCM_USE_AITER_SAMPLING=1 
ulimit -c 0
# export VLLM_TORCH_PROFILER_DIR="/home/duwang/profiling"
# export MODEL_PATH=/shared-inference/models_blog/Deepseek-r1-FP8-Dynamic
# MODEL_PATH=/mnt/m2m_nobackup/models/deepseek-ai/DeepSeek-V3-5layer
MODEL_PATH=/mnt/m2m_nobackup/models/deepseek-ai/DeepSeek-V3

mkdir -p /mnt/m2m_nobackup/local_logs/

vllm serve $MODEL_PATH\
        -tp 1 \
		-dp 8 \
		--enable-expert-parallel \
        --port 20005 \
        --block-size 16 \
		--max-num-batched-tokens 4096 \
        --distributed-executor-backend mp \
        --gpu_memory_utilization 0.85 \
        --max-model-len 4096 \
        --enforce-eager \
        --trust-remote-code \
           --kv-transfer-config '{"kv_connector":"MoRIIOConnector","kv_role":"kv_producer","kv_port":"9711","kv_connector_extra_config":{"proxy_ip":"10.158.214.178","proxy_port":"30001","proxy_ping_port":"36367","local_ping_port":"61555","http_port":"20005","handshake_port":8405,"notify_port":61005}}' \
        2>&1 | tee /mnt/m2m_nobackup/local_logs/vllm_prefill_server.log   