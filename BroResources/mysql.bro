@load base/protocols/mysql

module TophantMySQL;

export {
    #redef record MySQL::Info += {P: count &log &default=7;};
    redef Kafka::logs_to_send += set(mysql::LOG);
}


event bro_init()
        {
        Tophant::debug(fmt("create log stream for mysql::LOG with columns=mysql::Info"));
        Log::create_stream(mysql::LOG, [$columns=MySQL::Info, $path="protocol.mysql"]);
        }