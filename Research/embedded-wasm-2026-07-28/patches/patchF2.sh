#!/bin/bash
# Blocker F (measurement hack): drop inline Codable/Encodable/Decodable from type declarations.
# NOT a proposed fix - proper remediation moves the conformance to a gated extension.
D="$1/checkouts"; chmod -R u+w "$D" 2>/dev/null
python3 - "$D" <<'PY'
import os,re,sys
rx=re.compile(r'^(\s*(?:public |internal |package )?(?:struct|enum|final class|class|actor) [^\n{]*?)(,\s*(?:Codable|Encodable|Decodable)\b|(?<=:)\s*(?:Codable|Encodable|Decodable)\s*,)([^\n{]*\{)', re.M)
n=f=0
for dp,_,fs in os.walk(sys.argv[1]):
    for fn in fs:
        if not fn.endswith(".swift"): continue
        p=os.path.join(dp,fn)
        try: t=open(p,encoding="utf-8").read()
        except: continue
        t2,c=rx.subn(lambda m: m.group(1)+m.group(3), t)
        if c: open(p,"w",encoding="utf-8").write(t2); n+=c; f+=1
print("patchF2:",n,"inline conformances dropped in",f,"files")
PY
