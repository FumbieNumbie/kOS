set alpha to 5.
lock steering to st.
until AG10{
  set st to heading(90,alpha).
  on AG7 set alpha to alpha+2.5.
  on AG6 set alpha to alpha-2.5.
}
