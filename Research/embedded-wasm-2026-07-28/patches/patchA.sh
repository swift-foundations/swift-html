#!/bin/bash
# Blocker A workaround: StringLiteralType -> String in ExpressibleByStringLiteral inits.
D="$1/checkouts"; [ -d "$D" ] || { echo "no checkouts at $D"; exit 1; }
chmod -R u+w "$D" 2>/dev/null
python3 - "$D" <<'PY'
import os,sys
n=0
for dp,_,fs in os.walk(sys.argv[1]):
    for fn in fs:
        if fn.endswith(".swift"):
            p=os.path.join(dp,fn)
            try: t=open(p,encoding="utf-8").read()
            except: continue
            if "stringLiteral value: StringLiteralType" in t:
                n+=t.count("stringLiteral value: StringLiteralType")
                open(p,"w",encoding="utf-8").write(t.replace("stringLiteral value: StringLiteralType","stringLiteral value: String"))
print("patchA:",n,"sites")
PY
