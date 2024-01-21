export TF_VAR_tenancy_ocid=<tenancy_ocid>
export TF_VAR_user_ocid=<user_ocid>
export TF_VAR_fingerprint=<fingerprint>
export TF_VAR_region=<region>
export TF_VAR_config_file_profile=<config_file_profile>
export TF_VAR_ssh_public_key=$(cat id_rsa.pub)
export TF_VAR_ssh_private_key=$(cat id_rsa)
export TF_VAR_private_key_path="terraform/private_key.pem"
# It must be the same as the one in OCI cofing file
export TF_VAR_oci_profile="PICK"