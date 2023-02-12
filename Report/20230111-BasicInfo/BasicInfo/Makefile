PROJECT:=BasicInfo

BUILD_DIR:=build

OUTPUT:=${BUILD_DIR}/${PROJECT}.pdf

FLAGS:=-xelatex -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=${BUILD_DIR}

TEXS:=\
	${PROJECT}.tex

default: ${BUILD_DIR} ${OUTPUT}
	@echo Makefile: Done!

${OUTPUT}: ${TEXS}
	latexmk ${FLAGS} ${PROJECT}.tex 

${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}

run:default
	firefox file:///$(shell cygpath -a -m ${OUTPUT})

clean:
	rm ${BUILD_DIR}/${PROJECT}.*

output:
	@echo ${OUTPUT}