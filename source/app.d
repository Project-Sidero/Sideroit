extern(C) int main()
{
    import sidero.sideroit.database.utils;
    import sidero.eventloop.control;

    cast(void)startWorkerThreads;
    cast(void)startUpNetworking;

    SideroitConfig sideroitConfig;
    loadSideroitConfig(sideroitConfig);
    return 0;
}
