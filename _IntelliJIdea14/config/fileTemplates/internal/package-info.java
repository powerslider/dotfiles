#set( $newline="
")
#parse("File Header.java")
#if (${PACKAGE_NAME} && ${PACKAGE_NAME} != "")
@ParametersAreNonnullByDefault${newline} package ${PACKAGE_NAME};#end

import javax.annotation.ParametersAreNonnullByDefault;