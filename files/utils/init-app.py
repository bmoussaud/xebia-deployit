import sys
import string

# methods
def makeRole(name):
	print "making role %s" % (name)
	security.assignRole(name, [] )
	return name

def makeEmptyCI(name, type):
	return makeCI(name, type, {})

def makeCI(name, type, values):
	print "making %s %s" % (type, name)
	if (repository.exists(name)):
		print " already exists"
	else:
		ci = repository.create(factory.configurationItem(name, type, values))
	return name

def getCiFolders(ci):
	elems = string.split(ci, '/')
	folders = []
	for i in range(1, len(elems) + 1):
		folders.append('/'.join(elems[0:i]))

	return folders

def makeFolder(name):
	folder = makeEmptyCI(name, 'core.Directory')
	print "created folder %s" % (folder)
	return folder

def makeDictionary(params):
	name = "Environments/%(app)s/%(env)s/%(scope)s-dictionaries/%(app)s-dict" % params
	return makeEmptyCI(name, 'udm.Dictionary')

def makeEncryptedDictionary(params):
	name = "Environments/%(app)s/%(env)s/%(scope)s-dictionaries/%(app)s-enc-dict" % params
	return makeEmptyCI(name, 'udm.EncryptedDictionary')

def makePipeline(name, members):
	return makeCI(name, 'release.DeploymentPipeline', {'pipeline': members} )

def makeEnvironment(appname, environ):
	dictionaries = [
		makeEmptyCI("Environments/platform-dictionaries/%s/platform-enc-dict" % (environ), 'udm.EncryptedDictionary'),
		makeEmptyCI("Environments/platform-dictionaries/%s/platform-dict" % (environ), 'udm.Dictionary'),
		makeEncryptedDictionary( {"app": appname, "env": environ, "scope": "provisioning"} ),
		makeDictionary( {"app": appname, "env": environ, "scope": "provisioning"} ),
		makeEncryptedDictionary( {"app": appname, "env": environ, "scope": "application"} ),
		makeDictionary( {"app": appname, "env": environ, "scope": "application"} )
	]

	name = "Environments/%(app)s/%(env)s/%(app)s-%(env)s" % {"app": appname, "env": environ} 
	return makeCI(name, 'udm.Environment', {'dictionaries': dictionaries} )

def grantPermissions(permissions, role, ci):
	for permission in permissions:
		print "grant %s to role %s for %s" % (permission, role, ci)
		security.grant(permission, role, [ci])
	grantReadPermissionsToCiTree(role, ci)

def grantReadPermissionsToCiTree(role, ci):
	folders = getCiFolders(ci)
	print "grant %s to role %s for %s" % ('read', role, folders)
	security.grant('read', role, folders)

def makeAllEnvironmentSpecificCIs(appname, environ, provisionRole, appPipelineFolder):
	params = {"app": appname, "env": environ}
	
	deployRole = makeRole("%(app)s-deploy-%(env)s" % params )
	
	environmentFolder = makeFolder("Environments/%(app)s/%(env)s" % params)
	
	platformDictionariesFolder = makeFolder("Environments/platform-dictionaries/%(env)s" % params)
	applicationDictionariesFolder = makeFolder("Environments/%(app)s/%(env)s/application-dictionaries" % params)
	provisioningDictionariesFolder = makeFolder("Environments/%(app)s/%(env)s/provisioning-dictionaries" % params)
	
	makeFolder("Infrastructure/%(env)s" % params)
	infrastructureFolder = makeFolder("Infrastructure/%(env)s/%(app)s" % params)
	
        # deployRole permissions
	grantPermissions(['repo#edit'], deployRole, applicationDictionariesFolder)
	grantPermissions([], deployRole, provisioningDictionariesFolder)
	grantPermissions([], deployRole, platformDictionariesFolder)
	grantPermissions([], deployRole, applicationFolder)
	grantPermissions(['deploy#initial', 'deploy#upgrade', 'deploy#undeploy', 'task#skip_step'], deployRole, environmentFolder)
	grantPermissions(['controltask#execute'], deployRole, infrastructureFolder)
	grantPermissions([], deployRole, appPipelineFolder)

        # provisionRole permissions
	grantPermissions(['repo#edit'], provisionRole, provisioningDictionariesFolder)
	grantPermissions(['repo#edit'], provisionRole, environmentFolder)
	grantPermissions(['repo#edit', 'controltask#execute'], provisionRole, infrastructureFolder)
	
	return makeEnvironment(appname, environ)


# start main
appname = sys.argv[1]

# create common roles
loginRole = makeRole("login")
provisionRole = makeRole("provision")
importAppRole = makeRole("%s-import" % (appname) )

# create common folders
applicationFolder = makeFolder("Applications/%s" % (appname) )

makeFolder("Environments/platform-dictionaries")
makeFolder("Environments/%s" % (appname) )

appPipelineFolder = makeFolder("Configuration/%s" % (appname) )

# set common permissions, permission 'read' on all (parent) folders is implied 
grantPermissions(['repo#edit', 'import#initial', 'import#upgrade', 'import#remove'], importAppRole, applicationFolder)
grantPermissions(['repo#edit'], provisionRole, "Infrastructure")
grantPermissions([], loginRole, "Infrastructure")

# set global permissions
security.grant("login", loginRole)
security.grant("discovery", provisionRole)

# create environments

testEnv = makeAllEnvironmentSpecificCIs(appname, "test", provisionRole, appPipelineFolder)
acceptatieEnv = makeAllEnvironmentSpecificCIs(appname, "acceptatie", provisionRole, appPipelineFolder)
productieEnv = makeAllEnvironmentSpecificCIs(appname, "productie", provisionRole, appPipelineFolder)

# make pipeline
makePipeline("Configuration/%(app)s/%(app)s-pipeline" % {"app": appname}, [testEnv, acceptatieEnv, productieEnv] )


