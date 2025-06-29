# Discrepancies Report (between spec and impl)

1. ✅ RESOLVED: FAB Behavior Mismatch
   - **Issue**: Specification said Planning Tab FAB should open Select Dancers Screen and Present Tab FAB should open Add Dancer Dialog, but implementation always opened Select Dancers Screen.
   - **Solution**: Implemented tab-specific FAB behavior with EventTabActions interface.

2. ✅ RESOLVED: Planning Tab Mark Present Action
   - **Issue**: Specification mentioned quick context action blue location icon button for absent dancers.
   - **Decision**: Removed quick action button to prevent accidental taps. "Mark Present" action is available in context dialog when tapping dancer card.

3. ✅ RESOLVED: "Ranked Tab" Reference in Specification
   - **Issue**: Specification mentioned "Ranked tab" but implementation only has Planning and Present tabs.
   - **Solution**: Updated specification to remove references to non-existent "Ranked tab".

All major discrepancies have been resolved! 🎉