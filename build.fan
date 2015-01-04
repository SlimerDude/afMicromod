using build

class Build : BuildPod {
	
	// to compile (from the cmd line) you'll need to copy the .jar to C:\Apps\fantom-1.0.63\lib\java\ext
	// see http://fantom.org/sidewalk/topic/1799
	// "Also we don't support using Java FFI on yourself - so you should build jade.jar as a pod by 
	// itself and then have your pod depend on it. Or just stick jade.jar in 'lib/java/ext' "
	
	new make() {
		podName = "afMicromod"
		summary = "A wrapper around Micromod; a music player for MOD, S3M, and XM files."
		version = Version([1,0,2])
		
		meta	= [	"org.name"		: "MuMart",
					"org.uri"		: "https://sites.google.com/site/mumart/home/micromodibxm",
					"proj.name"		: "MicroMod",
					"vcs.name"		: "Subversion",
               		"vcs.uri"		: "http://micromod.googlecode.com/svn/trunk/",
               		"license.name"	: "BSD New"
				  ]
		
		srcDirs = [`test/`, `fan/`, `fan/util/`]
		depends = ["sys 1.0", "concurrent 1.0"]
		resDirs = [`lib/java/ibxm-a61.jar`, `res/music/`]

		docApi = true
		docSrc = true
	}
}