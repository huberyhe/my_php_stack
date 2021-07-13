all:
	rm -rf output_self
	mkdir -p output_self
	dos2unix release/self_exec.sh
	chmod a+x release/start_upgrade.sh
	cp release/start_upgrade.sh output_self/
	cp src output_self/ -Ra
	tar -cf app_self.tar -C output_self .
	cat release/self_exec.sh app_self.tar > release/pkg_`date +%Y%m%d`.csu

clean:
	rm -rf output_self
	rm -f app_self.tar
