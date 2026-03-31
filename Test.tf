resource "google_compute_project_metadata" "clvqa-project" {
  metadata = {
    enable-oslogin = "TRUE"               #CKV_GCP_33
  }
}

resource "google_compute_instance" "pwqa-instance" {
  name         = "clvqa-gcp-instance"
  machine_type = "e2-medium"
  zone         = "us-central1-a"
  can_ip_forward = false                                 #CKV_GCP_36
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
	disk_encryption_key_raw = "TestGcpEncrypt"            #CKV_GCP_38
  }
  /*access_config {
        nap_ip = "10.0.42.42"                              #CKV_GCP_40
   }*/
  shielded_instance_config {
		 enable_integrity_monitoring = true              #CKV_GCP_39
         enable_vtpm = true                              #CKV_GCP_39
		 
  }
  metadata = {
	  serial-port-enable = false                        #CKV_GCP_35
      block-project-ssh-keys = true                     #CKV_GCP_32
	  enable-oslogin = true                             #CKV_GCP_34
	 }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"
	access_config {
      }
   }

  metadata_startup_script = "echo hi > /test.txt"
  
service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
	email  = "waykole.prashant@gmail.com"                               #CKV_GCP_30
    scopes = ["	https://www.googleapis.com/auth/compute.readonly"]      #CKV_GCP_31 
  }
}
