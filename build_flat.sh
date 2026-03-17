#!/bin/bash
# Build flat HTML files from the PHP template system
# This script is a one-time migration tool

NAV_TEMPLATE='<div class="bannerimg"> <img src="img/diag.png" alt="genetrack banner" >
  <div class="title"><span>Chikina Lab</span></div></div>
<div id="navigate">
<h4>Navigation</h4>
<ul id="navlinks">
  <li id="homelink">
<a class="HOMECLASS" href="index.html">Home</a>
</li>

<li id="projectslink">
<a class="PROJECTSCLASS" href="projects.html">Projects</a>
</li>

<li id="toolslink">
<a class="TOOLSCLASS" href="tools.html">Tools</a>
</li>


<li id="peoplelink">
<a class="PEOPLECLASS" href="people.html">People</a>
</li>

</ul>
</div>'

make_nav() {
    local active="$1"
    local nav="$NAV_TEMPLATE"
    if [ "$active" = "home" ]; then
        nav="${nav//HOMECLASS/active}"
    else
        nav="${nav//HOMECLASS/inactive}"
    fi
    if [ "$active" = "projects" ]; then
        nav="${nav//PROJECTSCLASS/active}"
    else
        nav="${nav//PROJECTSCLASS/inactive}"
    fi
    if [ "$active" = "tools" ]; then
        nav="${nav//TOOLSCLASS/active}"
    else
        nav="${nav//TOOLSCLASS/inactive}"
    fi
    if [ "$active" = "people" ]; then
        nav="${nav//PEOPLECLASS/active}"
    else
        nav="${nav//PEOPLECLASS/inactive}"
    fi
    echo "$nav"
}

FOOT='<!-- Default Statcounter code for Chikinlab
http://chikinlab.org -->
<script type="text/javascript">
var sc_project=11748090;
var sc_invisible=1;
var sc_security="faa9c7cd";
</script>
<script type="text/javascript"
src="https://www.statcounter.com/counter/counter.js"></script>
<noscript><div class="statcounter"><a title="Web Analytics
Made Easy - StatCounter" href="http://statcounter.com/"
><img class="statcounter"
src="//c.statcounter.com/11748090/0/faa9c7cd/1/" alt="Web
Analytics Made Easy - StatCounter"></a></div></noscript>
<!-- End of Statcounter Code -->'

# --- index.html ---
cat > index.html <<ENDOFFILE
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
	  "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <title>Chikina Lab</title>
    <meta name="author" content="Chikina Lab">
    <meta name="description"  content="Maria Chikina lab at the University of Pittsburgh School of Medicine.">
    <meta name="keywords" content="">
    <link rel="stylesheet" href="style.css" type="text/css" media="screen">
  </head>

  <body>
    <div class="box">
$(make_nav home)

      <div class="content">

$(cat c-home.html)

	<h1> Our Home</h1>
	<div class="leftlogobox">
	  <img class="logo" src="img/pittseal.jpg" alt="Pitt Seal"><p class="address">
	    University of Pittsburgh School of Medicine<br>
	    <a href="http://csb.pitt.edu/">Department of Computational and Systems Biology</a><br>
	    3501 Fifth Ave,
	    Pittsburgh, PA 15260
	  </p>
	</div>
	<div class="rightlogobox">
	  <p class=address>
	    Carnegie Mellon - University of Pittsburgh<br>
	    <a href="http://www.compbio.cmu.edu/">Ph.D. Program in Computational Biology</a>
	  </p>
	  <a href="http://www.compbio.cmu.edu/"><img class="logo" src="img/cpcbseal.png" alt="Carnegie Mellon - University of Pittsburgh Ph.D. Program in Computational Biology"></a>
	</div>

$(cat c-news.html)

	<h2>Contact Maria</h2>
	<p class=address>
	  phone: 412 648 3338<br>
	  email: <a href="mailto:mchikina@pitt.edu">mchikina@pitt.edu</a></p>

	<br class="clear">
      </div>

$FOOT

    </div>
  </body>
</html>
ENDOFFILE

echo "Built index.html"

# --- projects.html ---
cat > projects.html <<ENDOFFILE
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
	  "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <title>Chikina Lab</title>
    <meta name="author" content="Chikina Lab: Projects">
    <meta name="description"  content="Maria Chikina lab at the University of Pittsburgh medical school: Projects">
    <meta name="keywords" content="">
    <link rel="stylesheet" href="style.css" type="text/css" media="screen">
  </head>
  <body>
    <div class="box">
$(make_nav projects)
      <div class="content">
$(cat c-projects.html)
      </div>
$FOOT
    </div>
  </body>
</html>
ENDOFFILE

echo "Built projects.html"

# --- tools.html ---
cat > tools.html <<ENDOFFILE
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
	  "http://www.w3.org/TR/html4/strict.dtd">
<html>
  <head>
    <title>Chikina Lab</title>
    <meta name="author" content="Chikina Lab: Tools">
    <meta name="description"  content="Maria Chikina lab at the University of Pittsburgh medical school: Tools">
    <meta name="keywords" content="">
    <link rel="stylesheet" href="style.css" type="text/css" media="screen">
  </head>

  <body>

    <div class="box">
$(make_nav tools)

      <div class="content">
$(cat c-tools.html)
      </div>

$FOOT

    </div>
  </body>
</html>
ENDOFFILE

echo "Built tools.html"

# --- people.html ---
cat > people.html <<ENDOFFILE
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
   "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
  <title>Chikina Lab: People</title>
  <meta name="author" content="Chikina Lab">
  <meta name="description"  content="Maria Chikina lab at the University of Pittsburgh medical school: People">
<meta name="keywords" content="">
 <link rel="stylesheet" href="style.css" type="text/css" media="screen">
</head>

<body>

  <div class="box">
$(make_nav people)


    <div class="content">

$(cat c-people.html)



<div id="UPMCdiv">
  <a title="University of Pittsburgh Medical School &#013;&#013; taken by Something Original at English Wikipedia [CC BY-SA 3.0 (https://creativecommons.org/licenses/by-sa/3.0) or GFDL (http://www.gnu.org/copyleft/fdl.html)], from Wikimedia Commons"><img width="1024" alt="University of Pittsburgh (looking South-West) seen from the Cathedral of Learning May 14, 2010" src="img/Pitt.jpg"></a>
<img id="BST3arrow" alt="arrow" src="img/arrow.png">
</div>




<br class="clear">

</div>

$FOOT
  </div>

</body>



</html>
ENDOFFILE

echo "Built people.html"

# --- pub.html ---
cat > pub.html <<ENDOFFILE
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">

<html>
  <head>
    <meta http-equiv="content-type"
	  content="text/html; charset=utf-8">
    <title>Publications</title>
    <meta name="author" content="Chikina Lab: Publications">
    <meta name="description"
	  content="Maria Chikina lab at the University of Pittsburgh medical school: Publications">
    <meta name="keywords" content="">
    <link rel=stylesheet href="style.css" type="text/css" media="screen">

    <script type="text/x-mathjax-config">
      MathJax.Hub.Config({
      SVG: {matchFontHeight: false},
      tex2jax: {inlineMath: [['\$','\$'], ['\\\\(','\\\\)']]}
      });
    </script>
    <script type="text/javascript"
	    src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.2/MathJax.js?config=TeX-MML-AM_CHTML">
    </script>


    <script type="text/javascript">
      function unhide(divID) {
      var item = document.getElementById(divID);
      if (item) {
      item.className=(item.className=='hidden')?'unhidden':'hidden';
      }
      }
    </script>
  </head>

  <body>
    <div class="box">
$(make_nav pub)
      <div class="content">
	<h1> Publications </h1>
$(cat c-pub.html)
      </div>
$FOOT
    </div>
  </body>
</html>
ENDOFFILE

echo "Built pub.html"
echo "All pages built successfully!"
