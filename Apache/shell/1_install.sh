#!/bin/bash
# Apache Build Script
# Author: https://ko-o.tistory.com/
# Date: 2025.10.02

#################################################
# *. Spinner
#################################################
spinner() {
  local pid=$1
  local delay=0.2
  local spinstr='|/-\'
  while kill -0 $pid 2>/dev/null; do
    for i in $(seq 0 3); do
      printf "\r → ${spinstr:$i:1}  "
      sleep $delay
    done
  done
  printf "\r"  # delete spinner line
}

echo -e "\033c"

#################################################
# 0. tarballs
#################################################
echo "[STEP 0/5] Extracting tarballs..."
find "${APACHE_HOME}/tarballs" -maxdepth 1 -name "*.tar.gz" \
  -exec sh -c 'tar -zxvf "$1" -C "${APACHE_HOME}/tarballs" > /dev/null 2>&1 && rm -rf "$1"' _ {} \;
echo " ✔ Tarballs extracted."


#################################################
# 1.openssl                          
#################################################
echo "[STEP 1/5] Building OpenSSL..."
(
	cd ${APACHE_HOME}/tarballs/${VER_OPENSSL}
	./Configure linux-x86_64 --prefix=${APACHE_LIBS_HOME}/${VER_OPENSSL} \
		> configure.log 2>&1 &
	pid=$!	
	spinner $pid
	wait $pid

	make >> make.log 2>&1 &
	pid=$!	
	spinner $pid
	wait $pid

	make install >> make-install.log 2>&1 &
	pid=$!	
	spinner $pid
	wait $pid

)
echo " ✔ OpenSSL build completed."


#################################################
# 2.apr                              
#################################################
echo "[STEP 2/5] Building APR..."
(
	cd ${APACHE_HOME}/tarballs/${VER_APR}
	./configure --prefix=${APACHE_LIBS_HOME}/${VER_APR} \
	    > configure.log 2>&1 &
	pid=$!	
	spinner $pid
	wait $pid

	make >> make.log 2>&1 &
	pid=$!
	spinner $pid
	wait $pid

	make install >> make-install.log 2>&1 &
	pid=$!
	spinner $pid
	wait $pid
)
echo " ✔ APR build completed."


#################################################
# 3.apr-util                         
#################################################
echo "[STEP 3/5] Building APR-util..."
(
  	cd ${APACHE_HOME}/tarballs/${VER_APRUTIL}
  	./configure --prefix=${APACHE_LIBS_HOME}/${VER_APRUTIL} \
 	     --with-apr=${APACHE_LIBS_HOME}/${VER_APR} \
	      > configure.log 2>&1 &
	pid=$!	
	spinner $pid
	wait $pid

  	make >> make.log 2>&1 &
  	pid=$!
  	spinner $pid
  	wait $pid

  	make install >> make-install.log 2>&1 &
  	pid=$!
  	spinner $pid
  	wait $pid
)
echo " ✔ APR-util build completed."


#################################################
# 4.pcre
#################################################
echo "[STEP 4/5] Building PCRE..."
(
  	cd ${APACHE_HOME}/tarballs/${VER_PCRE}
  	./configure --prefix=${APACHE_LIBS_HOME}/${VER_PCRE} \
	      > configure.log 2>&1 &
	pid=$!	
	spinner $pid
	wait $pid

  	make >> make.log 2>&1 &
  	pid=$!
  	spinner $pid
  	wait $pid

  	make install >> make-install.log 2>&1 &
  	pid=$!
  	spinner $pid
  	wait $pid
)
echo " ✔ PCRE build completed."

export PATH=${PCRE_HOME}/bin:$PATH


#################################################
# 5.apache                           @TmaxSoft  #
#################################################
echo "[STEP 5/5] Building Apache HTTPD..."
(
	cd ${APACHE_HOME}/tarballs/httpd*
	./configure \
	  --prefix=${APACHE_ENGINE_HOME} \
	  --enable-module=so \
	  --enable-so \
	  --enable-ssl \
	  --with-mpm=worker \
	  --with-apr=${APR_HOME} \
	  --with-apr-util=${APRUTIL_HOME} \
	  --with-pcre=${PCRE_HOME} \
	  --enable-modules=reallyall \
	  --enable-mods-shared=reallyall \
	  --enable-mpms-shared=all \
	  --with-ssl=${OPENSSL_HOME} \
	    > configure.log 2>&1 &
	pid=$!	
	spinner $pid
	wait $pid

	make >> make.log 2>&1 &
	pid=$!
	spinner $pid
	wait $pid

	make install >> make-install.log 2>&1 &
	pid=$!
	spinner $pid
	wait $pid
)
echo " ✔ Apache HTTPD build completed."
