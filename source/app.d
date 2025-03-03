extern(C) int main()
{
    import sidero.sideroit.database.peruserconfig;
    import sidero.eventloop.control;

    cast(void)startWorkerThreads;
    cast(void)startUpNetworking;

    SideroitPerUserConfig sideroitPerUserConfig;
    loadSideroitPerUserConfig(sideroitPerUserConfig);
    return 0;
}
