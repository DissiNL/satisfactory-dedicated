FROM cm2network/steamcmd:root
#BUILD: docker build -t satisfactory .
#RUN: mkdir data; docker run -p 15000:15000/udp -p 7777:7777/udp -p 15777:15777/udp -d --name=satisfactory -v $(pwd)/data:/home/steam/Satisfactory-dedicated satisfactory
ENV STEAMAPPID 1690800
ENV STEAMAPP Satisfactory
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
RUN echo -e "export LD_LIBRARY_PATH=${STEAMAPPDIR}/linux64:$LD_LIBRARY_PATH\n\
bash ${STEAMCMDDIR}/steamcmd.sh +login anonymous +force_install_dir ${STEAMAPPDIR} +app_update ${STEAMAPPID} validate +quit\n\
test -d ~/.config/Epic/FactoryGame/Saved || mkdir -p ~/.config/Epic/FactoryGame/Saved\n\
test -d ${STEAMAPPDIR}/saves || mkdir ${STEAMAPPDIR}/saves\n\
test -L ~/.config/Epic/FactoryGame/Saved/SaveGames || ln -s ${STEAMAPPDIR}/saves ~/.config/Epic/FactoryGame/Saved/SaveGames\n\
${STEAMAPPDIR}/FactoryServer.sh" >> ${HOMEDIR}/entry.sh
RUN chmod +x "${HOMEDIR}/entry.sh" && chown -R "${USER}:${USER}" "${HOMEDIR}"
USER ${USER}
VOLUME ${STEAMAPPDIR}
WORKDIR ${HOMEDIR}
CMD ["bash", "entry.sh"]
EXPOSE 15777/udp 15000/udp 7777/udp
