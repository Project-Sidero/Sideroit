import sidero.base.allocators;

extern(C) int main()
{
    import sidero.sideroit.database.peruserconfig;
    import sidero.sideroit.database.localpackages;
    import sidero.eventloop.control;

    cast(void)startWorkerThreads;
    cast(void)startUpNetworking;

    PerUserConfig perUserConfig;
    LocalPackages localPackages;

    loadPerUserConfig(perUserConfig);
    loadLocalPackages(perUserConfig, localPackages);

    import sidero.sideroit.packages;
    Packages packages = Packages(globalAllocator());

    Unit* unit = packages.newUnit();
    Artifact* artifact = packages.newArtifact();
    ArtifactOption* artifactOption = packages.newArtifactOption();
    Aspect* aspect = packages.newAspect();

    return 0;
}
