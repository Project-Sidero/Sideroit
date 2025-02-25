module sidero.sideroit.state;
import sidero.sideroit.packages;
import sidero.base.containers.dynamicarray;
import sidero.base.containers.map.hashmap;
import sidero.base.text;

struct State {
    UnitRef rootUnit;

    HashMap!(String_UTF8, UnitRef) namedUnits;
    DynamicArray!UnitRef unnamedUnits;
}
