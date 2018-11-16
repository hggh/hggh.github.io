---
layout: post
title:  "Puppet - profiles with support of different module versions"
date:   2016-08-17 12:55:45
categories: puppet debian
---

<p>At Globalways we are using the profile / roles layout for our puppet infrastructure.</p>

<p>The profiles are shared all over our different customer environments - so we have one place for our profiles.</p>

<p>This is a good solution until you need to support different module versions. But with Puppet future 
parser it is getting better.</p>

<p>Our example is the tomcat module from PuppetLabs. With the version 1.5.0 there is new option &#39;manage_service&#39;.</p>

<p>The code before supporting 1.5.0 looks like:</p>

<div class="highlight"><pre><code class="language-puppet" data-lang="puppet"># install and prepare default tomcat instance
tomcat::instance { &#39;default7&#39;:
  package_name   =&gt; &#39;tomcat7&#39;,
  catalina_home  =&gt; &#39;/var/lib/tomcat7&#39;,
  package_ensure =&gt; $package_ensure,
}</code></pre></div>

<p>If the environment is using version 1.5.0 or greater the manage_service option should be false for our needs.</p>

<div class="highlight"><pre><code class="language-puppet" data-lang="puppet">$metadata = load_module_metadata(&#39;tomcat&#39;, true)
if (versioncmp($metadata[&#39;version&#39;], &#39;1.5.0&#39;) &gt;= 0) {
  $tomcat_options = {
    &#39;manage_service&#39; =&gt; false,
  }
}
else {
  $tomcat_options = {}
}
# install and prepare default tomcat instance
tomcat::instance { &#39;default7&#39;:
  package_name   =&gt; &#39;tomcat7&#39;,
  catalina_home  =&gt; &#39;/var/lib/tomcat7&#39;,
  package_ensure =&gt; $package_ensure,
  *              =&gt; $tomcat_options,
}</code></pre></div>

<p>We are reading the module version with the stdlib function and then using a future parser option, to use a hash as options for the define.</p>

<p>We are now able to support more versions of the tomcat module within one profile.</p>
