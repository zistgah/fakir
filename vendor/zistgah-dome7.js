/* zistgah DOME7 — reused VERBATIM from zistgah/zistgah.github.io index.html (script block 2, DOME7-BEGIN..END).
   (c) 1993-2026 Abhishek Choudhary. All rights reserved. AyeAI. Do not reinvent this dome. */
/*DOME7-BEGIN  diagrid shell + clustered-column arcade — pure, tested ----------*/
function domePoint(v,th,R,phi0,phi1){
  const phi=phi0+(phi1-phi0)*v, s=Math.sin(phi), c=Math.cos(phi);
  return [R*s*Math.cos(th), R*c, R*s*Math.sin(th)];
}
function makeDome(R){
  const phi0=Math.asin(0.17), phi1=78*Math.PI/180;
  const NR=14, M=30, TW=0.5;
  const P=(i,j)=>domePoint(i/NR, ((j+(i%2)*TW)%M)/M*2*Math.PI, R,phi0,phi1);
  const minor=[],major=[],seg=(A,a,b)=>A.push(a[0],a[1],a[2],b[0],b[1],b[2]);
  for(let i=0;i<NR;i++)for(let j=0;j<M;j++){
    const a=P(i,j), dl=P(i+1, i%2? j : j-1+M), dr=P(i+1, i%2? j+1 : j);
    const A=(j%4===0)?major:minor; seg(A,a,dl); seg(A,a,dr);
  }
  const rings=[];const ring=(v,n)=>{for(let k=0;k<n;k++){
    seg(rings,domePoint(v,k/n*6.28318,R,phi0,phi1),domePoint(v,(k+1)/n*6.28318,R,phi0,phi1))}};
  ring(0,64);ring(0.34,64);ring(0.67,64);ring(1,64);
  const arcade=[], rimR=R*Math.sin(phi1), botY=R*Math.cos(phi1);
  const bez=(p0,p1,p2,n)=>{const pts=[];for(let q=0;q<=n;q++){const t=q/n,u=1-t;
    pts.push([u*u*p0[0]+2*u*t*p1[0]+t*t*p2[0], u*u*p0[1]+2*u*t*p1[1]+t*t*p2[1],
              u*u*p0[2]+2*u*t*p1[2]+t*t*p2[2]])}return pts};
  const poly=(pts)=>{for(let q=0;q<pts.length-1;q++)seg(arcade,pts[q],pts[q+1])};
  const circleAt=(cx,cy,cz,r,n)=>{for(let k=0;k<n;k++){
    const a=k/n*6.28318,b=(k+1)/n*6.28318;
    seg(arcade,[cx+r*Math.cos(a),cy,cz+r*Math.sin(a)],[cx+r*Math.cos(b),cy,cz+r*Math.sin(b)])}};
  // every other azimuth midpoint carries one intricate column
  for(let j=0;j<M;j+=2){
    const thG=((j+0.5+TW)%M)/M*2*Math.PI;
    const bx=rimR*1.05*Math.cos(thG), bz=rimR*1.05*Math.sin(thG);
    const capY=botY*0.55;
    // clustered shafts: four slender verticals around the column axis
    for(let s2=0;s2<4;s2++){
      const sa=s2/4*6.28318+0.4, sr=0.10;
      const sx=bx+sr*Math.cos(sa), sz=bz+sr*Math.sin(sa);
      seg(arcade,[sx,0,sz],[sx,capY,sz]);
    }
    // base plinth + astragal + capital rings
    circleAt(bx,0.02,bz,0.20,10); circleAt(bx,0.14,bz,0.15,10);
    circleAt(bx,capY,bz,0.16,10); circleAt(bx,capY+0.12,bz,0.22,10);
    // twin gothic branches from the capital to the two adjacent shell nodes
    const n0=P(NR,j), n1=P(NR,(j+1)%M);
    for(const node of [n0,n1]){
      const ctrl=[(bx+node[0])/2*1.08, capY+(node[1]-capY)*0.55, (bz+node[2])/2*1.08];
      poly(bez([bx,capY+0.12,bz],ctrl,node,8));
      // inner counter-cusp: a second, tighter curve — the ornamental layer
      const ctrl2=[(bx+node[0])/2*0.99, capY+(node[1]-capY)*0.34, (bz+node[2])/2*0.99];
      poly(bez([bx,capY+0.12,bz],ctrl2,node,8));
    }
    // finial spike above the capital
    seg(arcade,[bx,capY+0.12,bz],[bx,capY+0.55,bz]);
  }
  const floor=[];
  for(const fr of [0.25,0.5,0.75,1.0]){
    for(let k=0;k<72;k++){const a=k/72*6.28318,b=(k+1)/72*6.28318,r=fr*R*0.92;
      floor.push(r*Math.cos(a),0.02,r*Math.sin(a), r*Math.cos(b),0.02,r*Math.sin(b))}}
  for(let k=0;k<12;k++){const a=k/12*6.28318;
    floor.push(0.6*Math.cos(a),0.02,0.6*Math.sin(a), R*0.92*Math.cos(a),0.02,R*0.92*Math.sin(a))}
  const F=x=>Float32Array.from(x);
  return {minor:F(minor),major:F(major),rings:F(rings),arcade:F(arcade),floor:F(floor),
          phi0,phi1,ocuY:R*Math.cos(phi0),ocuR:R*Math.sin(phi0),shellBottomY:botY,
          pedestals:[[-4.6,2.7],[-1.7,3.4],[1.7,3.4],[4.6,2.7]]};
}
/*DOME7-END*/
