set -e
set -o pipefail

NATIVE_IMAGE=/Library/Java/JavaVirtualMachines/graalvm-ce-java11-20.1.0/Contents/Home/lib/svm/bin/native-image

test -f $NATIVE_IMAGE || echo "Does not exist: $NATIVE_IMAGE"
test -f $NATIVE_IMAGE || exit 1


GRAALVM_HOME=/Library/Java/JavaVirtualMachines/graalvm-ce-java11-20.1.0/Contents/Home/

test -d $GRAALVM_HOME || echo "Does not exist: $GRAALVM_HOME"
test -d $GRAALVM_HOME || exit 1

$GRAALVM_HOME/bin/gu install native-image

./gradlew jar

JAR_WITH_DEPS=build/libs/graal_aotc_java-1.0.jar

test -f $JAR_WITH_DEPS || echo "Does not exist: $JAR_WITH_DEPS"
test -f $JAR_WITH_DEPS || exit 1

# java -jar build/libs/graal_aotc_java-1.0.jar

# Note: this is case-sensitive
nice $NATIVE_IMAGE -jar $JAR_WITH_DEPS --no-fallback --no-server -H:Class=com.HttpCatPure -H:Name=httpcatpure --allow-incomplete-classpath

./helloworld