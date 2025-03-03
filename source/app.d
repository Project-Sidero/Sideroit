extern(C) int main()
{
    import sidero.sideroit.database.peruserconfig;
    import sidero.eventloop.control;

    cast(void)startWorkerThreads;
    cast(void)startUpNetworking;

    SideroitPerUserConfig sideroitPerUserConfig;
    loadSideroitPerUserConfig(sideroitPerUserConfig);

    import sidero.sideroit.packages;
    Packages packages;

    Unit* unit = packages.newUnit();
    Artifact* artifact = packages.newArtifact();
    ArtifactOption* artifactOption = packages.newArtifactOption();
    Aspect* aspect = packages.newAspect();

    return 0;
}
