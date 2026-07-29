#!/bin/bash
# Blocker F workaround: gate standalone Codable/Encodable/Decodable conformance extensions.
D="$1/checkouts"; chmod -R u+w "$D" 2>/dev/null
python3 - "$D" <<'PY'
import os,re,sys
# one-line conformance extensions: "extension X: Codable {}" (optionally with where)
rx=re.compile(r'^(extension [^\n{]*?:\s*(?:Codable|Encodable|Decodable)\s*\{\s*\}\s*)$', re.M)
n=f=0
for dp,_,fs in os.walk(sys.argv[1]):
    for fn in fs:
        if not fn.endswith(".swift"): continue
        p=os.path.join(dp,fn)
        try: t=open(p,encoding="utf-8").read()
        except: continue
        if "hasFeature(Embedded)" in t: continue
        t2,c=rx.subn(r'#if !hasFeature(Embedded)\n\1\n#endif',t)
        if c: open(p,"w",encoding="utf-8").write(t2); n+=c; f+=1
print("patchF:",n,"conformances in",f,"files")
PY
