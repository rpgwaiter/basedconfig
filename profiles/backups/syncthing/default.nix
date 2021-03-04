{config, ...}:
{
    services.syncthing = {
        enable = true;
        user = "robots";
        group = "storage";
        declarative.devices = {
            storage.id = "BYOAPQT-KC6NT5Z-7TPVWDI-H63W5ZP-DBARUV5-U47DBCR-GTJEKEQ-2GZX7QM";
            storage.introducer = true;
        };
    };
}