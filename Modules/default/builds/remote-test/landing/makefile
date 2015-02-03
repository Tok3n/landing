all: REMOTETEST

LOCAL:
	gcloud preview app run . --project tok3n-landing

REMOTETEST:
	gcloud preview app deploy . --project tok3n-landing

PRODUCTION: REMOTETEST