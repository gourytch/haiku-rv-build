#! /bin/bash
set -ex
: ${BASE:=$1}
: ${BASE:=$(pwd)}
: ${NPROC:=$(nproc)}
LOG="${BASE}/$(basename $0 .sh)-$(date +'%Y%m%d_%H%M%S').log"
( # NESTED
echo "BASE  : '$BASE'"
echo "NPROC : '$NPROC'"
echo "LOG   : '$LOG'"
echo "STARTED AT $(date +'%Y-%m-%d %H:%M:%S')"

mkdir -p ${BASE}
cd ${BASE}

test -d ${BASE}/haiku \
|| git clone --depth=1 -b device_manager2-r2 https://github.com/X547/haiku.git ${BASE}/haiku

test -d ${BASE}/buildtools \
|| git clone --depth=1 https://review.haiku-os.org/buildtools.git ${BASE}/buildtools

test -d ${BASE}/haikuporter \
|| git clone --depth=1 https://github.com/haikuports/haikuporter.git ${BASE}/haikuporter

test -d ${BASE}/haikuports.cross \
|| git clone --depth=1 https://github.com/haikuports/haikuports.cross.git ${BASE}/haikuports.cross

test -d ${BASE}/haikuports \
|| git clone --depth=1 https://github.com/haikuports/haikuports.git ${BASE}/haikuports

if [ ! -e ${BASE}/bin/jam ] ; then
  cd ${BASE}/buildtools/jam
  make -j `nproc`
  mkdir -p ${BASE}/bin
  ./jam0 -sBINDIR=${BASE}/bin install
fi


cd ${BASE}/haiku
mkdir -p generated.riscv64
cd generated.riscv64

../configure \
    --use-gcc-pipe -j${NPROC} \
    --build-cross-tools riscv64 \
    --cross-tools-source ${BASE}/buildtools \
    --bootstrap ${BASE}/haikuporter/haikuporter ${BASE}/haikuports.cross ${BASE}/haikuports

# ${BASE}/bin/jam -j${NPROC} -q @bootstrap-raw
${BASE}/bin/jam -j${NPROC} -q @minimum-mmc
echo "FINISHED AT $(date +'%Y-%m-%d %H:%M:%S') WITH RC=$?"

) 2>&1 | tee "${LOG}"