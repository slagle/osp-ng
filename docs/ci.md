# CI

## OpenShift CI

Openshift CI Docs https://docs.ci.openshift.org/docs/

### Links

Useful Links https://docs.ci.openshift.org/docs/getting-started/useful-links/
Prow dashboard https://prow.ci.openshift.org/

### CI Operator

ci-operator docs https://docs.ci.openshift.org/docs/architecture/ci-operator/
ci-operator reference https://steps.ci.openshift.org/ci-operator-reference
ci-operator git https://github.com/openshift/ci-operator
ci-operator onboarding https://github.com/openshift/ci-operator/blob/master/ONBOARD.md

### OpenShift Release Tooling

https://github.com/openshift/release
https://github.com/openshift/release/blob/master/ci-operator/config/openstack-k8s-operators/dataplane-operator/openstack-k8s-operators-dataplane-operator-main.yaml
https://github.com/openshift/release/tree/master/ci-operator/step-registry/openstack-k8s-operators


## Github PR jobs

### pre-commit

pre-commit is "A framework for managing and maintaining multi-language
pre-commit hooks."

https://pre-commit.com/

Configured with `.pre-commit-config.yaml` in the root of a git repo.

pre-commit supports hooks provided by other git repos. A repo providing hooks
must contain a `.pre-commit-hooks.yaml` file in the root of the git repo.
