module sidero.sideroit.packages.state;
import sidero.sideroit.packages.unit;
import sidero.sideroit.packages.artifact;
import sidero.sideroit.packages.aspect;
import sidero.base.allocators;

struct Packages {
    private {
        RCAllocator allocator;

        Unit* unitCleanupLL;
        Artifact* artifactCleanupLL;
        ArtifactOption* artifactOptionCleanupLL;
        Aspect* aspectCleanupLL;
    }

export @safe nothrow @nogc:

    this(RCAllocator allocator) {
        this.allocator = allocator;
    }

    @disable this(this);

    ~this() {
        while(unitCleanupLL !is null) {
            Unit* next = unitCleanupLL;
            allocator.dispose(unitCleanupLL);
            unitCleanupLL = next;
        }

        while(artifactCleanupLL !is null) {
            Artifact* next = artifactCleanupLL;
            allocator.dispose(artifactCleanupLL);
            artifactCleanupLL = next;
        }

        while(artifactOptionCleanupLL !is null) {
            ArtifactOption* next = artifactOptionCleanupLL.artifactOptionCleanupLL;
            allocator.dispose(artifactOptionCleanupLL);
            artifactOptionCleanupLL = next;
        }

        while(aspectCleanupLL !is null) {
            Aspect* next = aspectCleanupLL.aspectCleanupLL;
            allocator.dispose(aspectCleanupLL);
            aspectCleanupLL = next;
        }
    }

    ///
    Unit* newUnit() {
        Unit* ret = allocator.make!Unit;
        ret.unitCleanupLL = unitCleanupLL;
        unitCleanupLL = ret;

        return ret;
    }

    ///
    Artifact* newArtifact() {
        Artifact* ret = allocator.make!Artifact;
        ret.artifactCleanupLL = artifactCleanupLL;
        artifactCleanupLL = ret;

        return ret;
    }

    ///
    ArtifactOption* newArtifactOption() {
        ArtifactOption* ret = allocator.make!ArtifactOption;
        ret.artifactOptionCleanupLL = artifactOptionCleanupLL;
        artifactOptionCleanupLL = ret;

        return ret;
    }

    ///
    Aspect* newAspect() {
        Aspect* ret = allocator.make!Aspect;
        ret.aspectCleanupLL = aspectCleanupLL;
        aspectCleanupLL = ret;

        return ret;
    }
}
