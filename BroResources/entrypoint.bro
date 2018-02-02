@load policy/tuning/json-logs
@load Bro/Kafka/logs-to-kafka

module Tophant;

export{
    global DEBUG: bool = F;
    function debug(msg: string){
        if(Tophant::DEBUG){
            print fmt("[DEBUG] %s - %s", strftime("%Y-%m-%d %H:%M:%S", current_time()), msg);
        }
    }
    global my_ip: string = "";
}


@unload /usr/local/bro/share/bro/policy/misc/scan.bro

@load ./mysql.bro

redef Kafka::kafka_conf = table(
    ["metadata.broker.list"] = "10.25.81.110:9092"
);

event bro_init() &priority=-5
{
    when (local output = Exec::run([$cmd="ifconfig | grep -A 1 en0 | tail -n 1 | awk '{print $2}'"])){
        if ( output$exit_code == 0 && |output$stdout| > 0){
            Tophant::my_ip = output$stdout[0];
            Tophant::debug(fmt("get my ip is %s", Tophant::my_ip));
        }
    }
    # remove default writer for every log stream
    for(log_id in Log::active_streams){
            if(! Tophant::DEBUG){
                print fmt("remove default filter for log id : %s", log_id);
#                Log::remove_default_filter(log_id);
        }
    }
}