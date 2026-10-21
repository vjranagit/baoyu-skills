#!/usr/bin/env bash
set -euo pipefail
[[ $# -eq 2 ]] || { echo 'usage: scripts/make.sh <content.json> <out-dir>' >&2; exit 2; }
content=$(realpath "$1")
out=$(realpath -m "$2")
script_dir=$(cd -- "$(dirname -- "$0")" && pwd)
skill_dir=$(cd -- "$script_dir/.." && pwd)
renderer="$script_dir/renderer.ts"
[[ -d "$skill_dir/node_modules/sharp" ]] || { echo 'Dependencies missing; run scripts/setup.sh' >&2; exit 3; }
mkdir -p "$out"
CONTENT="$content" OUT="$out" node <<'NODE'
const fs=require('fs'),c=JSON.parse(fs.readFileSync(process.env.CONTENT,'utf8'));
const need=(ok,m)=>{if(!ok)throw Error(m)},esc=s=>String(s).replace(/[&<>"']/g,x=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&apos;'}[x]));
need(c.title&&c.title.length<=48&&c.subtitle&&c.subtitle.length<=80&&c.footer&&c.footer.length<=95,'title, subtitle, and footer required and bounded');need(Array.isArray(c.nodes)&&c.nodes.length===6,'exactly six nodes required');
need(c.nodes.every(n=>n.label&&n.detail&&n.label.length<=26&&n.detail.length<=48),'six concise labeled nodes required');
const w=1600,h=1120,positions=[[88,280],[600,280],[1112,280],[1112,650],[600,650],[88,650]];
const links=[`<path d="M488 395H580"/>`,`<path d="M1000 395H1092"/>`,`<path d="M1312 510V630"/>`,`<path d="M1112 765H1020"/>`,`<path d="M600 765H500"/>`];
const wrap=s=>{const out=[];let line='';for(const word of s.split(/\s+/)){if((line+' '+word).trim().length>28&&line){out.push(line);line=word}else line=(line+' '+word).trim()}if(line)out.push(line);return out.slice(0,3)};
const cards=c.nodes.map((n,i)=>{const [x,y]=positions[i],fill=i<3?'#102d3a':'#172b42',lines=wrap(n.detail);return `<g transform="translate(${x} ${y})"><rect width="400" height="230" rx="18" fill="${fill}" stroke="${i<3?'#22d3ee':'#a78bfa'}" stroke-width="2"/><text x="24" y="38" class="step">${String(i+1).padStart(2,'0')} / FLOW</text><text x="24" y="94" class="node">${esc(n.label)}</text><text x="24" y="145" fill="#cbd5e1" font-size="18">${lines.map((v,j)=>`<tspan x="24" dy="${j?26:0}">${esc(v)}</tspan>`).join('')}</text></g>`}).join('');
const svg=`<svg xmlns="http://www.w3.org/2000/svg" xmlns:xhtml="http://www.w3.org/1999/xhtml" width="1600" height="1120" viewBox="0 0 1600 1120"><defs><pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse"><path d="M40 0H0V40" fill="none" stroke="#1e293b" stroke-width="1"/></pattern><style>text{font-family:Inter,Arial,sans-serif}.bg{fill:#0f172a}.eyebrow{font-size:14px;font-weight:700;letter-spacing:2px;fill:#22d3ee}.title{font-size:35px;font-weight:700;fill:#f8fafc}.subtitle{font-size:17px;fill:#cbd5e1}.node{font-size:24px;font-weight:700;fill:#f8fafc}.step{font-size:13px;font-weight:700;letter-spacing:1.5px;fill:#5eead4}.detail{font:18px Inter,Arial,sans-serif;color:#cbd5e1;line-height:1.4}</style><marker id="arrow" markerWidth="10" markerHeight="10" refX="8" refY="5" orient="auto"><path d="M0 0L10 5L0 10Z" fill="#94a3b8"/></marker></defs><rect class="bg" width="1600" height="1120"/><rect width="1600" height="1120" fill="url(#grid)"/><text x="88" y="92" class="eyebrow">QWEN BAOYU DIAGRAM</text><text x="88" y="150" class="title">${esc(c.title)}</text><text x="88" y="190" class="subtitle">${esc(c.subtitle)}</text>${links.join('')}${cards}<text x="88" y="1010" class="subtitle">${esc(c.footer)}</text></svg>`;
fs.writeFileSync(process.env.OUT+'/diagram.svg',svg);
NODE
(cd "$skill_dir" && npm exec --yes --package=bun -- bun "$renderer" "$out/diagram.svg" --scale 2 --output "$out/diagram.png" && npm exec --yes --package=bun -- bun "$renderer" "$out/diagram.svg" --scale 1 --output "$out/poster.png")
node -e 'const fs=require("fs"),sharp=require(process.argv[1]+"/node_modules/sharp");(async()=>{const p=process.argv[2]+"/diagram.png",m=await sharp(p).metadata();if(m.width!==3200||m.height!==2240||fs.statSync(p).size<10000)throw Error("invalid diagram export");console.log(JSON.stringify({status:"rendered",path:p,poster:process.argv[2]+"/poster.png",width:m.width,height:m.height}))})()' "$skill_dir" "$out"
