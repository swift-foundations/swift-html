#!/bin/bash
# Blocker E workaround: gate swift-ieee-754's DI-scoped exception state under Embedded.
F="$1/checkouts/swift-ieee-754/Sources/IEEE 754/IEEE_754.Exceptions.swift"
[ -f "$F" ] || { echo "patchE: file not found"; exit 0; }
chmod u+w "$F"
python3 - "$F" <<'PY'
import sys,re
p=sys.argv[1]; t=open(p,encoding="utf-8").read()
t=t.replace("public import Dependency_Primitives",
            "#if !hasFeature(Embedded)\npublic import Dependency_Primitives\n#endif")
t=t.replace("        Dependency.Scope.current[ExceptionState.self]\n",
            "        #if hasFeature(Embedded)\n        return _global\n        #else\n        Dependency.Scope.current[ExceptionState.self]\n        #endif\n")
t=t.replace("extension IEEE_754.Exceptions.ExceptionState: Dependency.Key {",
            "#if !hasFeature(Embedded)\nextension IEEE_754.Exceptions.ExceptionState: Dependency.Key {")
# close the gate at end of file
t=t.rstrip()+"\n#endif\n"
open(p,"w",encoding="utf-8").write(t)
print("patchE: applied")
PY
