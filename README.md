# css-generate-sources
源码生成通过指定格式的文本文件进行解析生成以及序列化和反序列化技术：avro|thrift|protobuf
## 一、avro技术
### 1.maven配置
```xml
<avro.version>1.8.2</avro.version>

<dependency>
	<groupId>org.apache.avro</groupId>
	<artifactId>avro-tools</artifactId>
	<version>${avro.version}</version>
</dependency>

<plugin>
	<groupId>org.apache.avro</groupId>
	<artifactId>avro-maven-plugin</artifactId>
	<version>${avro.version}</version>
	<executions>
		<execution>
			<phase>generate-sources</phase>
			<goals>
				<goal>schema</goal>
				<goal>protocol</goal>  
		<goal>idl-protocol</goal>
			</goals>
			<configuration>
				<sourceDirectory>${project.basedir}/src/main/resources/avro/</sourceDirectory>
				<outputDirectory>${project.basedir}/src/main/java/</outputDirectory>
				<stringType>String</stringType>
			</configuration>
		</execution>
	</executions>
</plugin>
```
### 2.maven编译
mvn clean compile

### 3.样例文件(json格式)
1)single class (*.avsc)
```json
{"namespace": "com.ucloudlink.css.avro.avsc",  
 "type": "record",
 "doc": "用户信息",
 "name": "User",
 "aliases": ["User1","User2"], 
 "fields": [  
     {"name": "id", "type": "long","doc": "主键ID","default": "0"},  
     {"name": "name", "type": "string","doc": "名字"},  
     {"name": "age",  "type": ["int", "null"],"doc": "年龄","default": "1"},  
     {"name": "list",  "type": [{"type":"array","items":"string"}, "null"],"doc": "年龄","default": "1"},  
     {"name": "map",  "type": [{"type":"map","values":"long"}, "null"],"doc": "年龄","default": "1"},  
     {"name": "fmd",  "type": [{"type":"fixed","size":16,"name":"md5"}, "null"],"doc": "年龄","default": "1"},  
     {"name": "email", "type": ["string", "null"],"doc": "邮箱"}
 ]  
}
```
2)mult class or method (*.avpr)
```json
{
	"namespace": "com.ucloudlink.css.avro.avpr",
	"protocol": "IUserDao",
	"doc": "user api",
	"types": [
	{
		"type": "record",
		 "doc": "组信息",
		 "name": "Group",
		 "aliases": ["Group1","Group2"], 
		 "fields": [
		     {"name": "id", "type": "long","doc": "主键ID","default": "0"},  
		     {"name": "name", "type": "string","doc": "名字"},  
		     {"name": "groupId",  "type": ["int", "null"],"doc": "groupId","default": "1"}
		 ] 
	},
	{
		"type": "record",
		 "doc": "组信息",
		 "name": "Organize",
		 "aliases": ["Organize1","Organize2"], 
		 "fields": [
		     {"name": "id", "type": "long","doc": "主键ID","default": "0"},  
		     {"name": "name", "type": "string","doc": "名字"},  
		     {
		     "name": "group", 
		     "type": [
		     	"null",
		     	{
		     		"type": "fixed", 
		     		"name": "Fad", 
		     		"size": 16
		     	}
		     	],
		     	"doc": "groupId"
		     }
		 ] 
	},
	{
		"type": "record",
		 "doc": "角色信息",
		 "name": "Role",
		 "aliases": ["Role1","Role2"], 
		 "fields": [
		     {"name": "id", "type": "long","doc": "主键ID","default": "0"},  
		     {"name": "name", "type": "string","doc": "名字"},  
		     {"name": "roleId",  "type": ["int", "null"],"doc": "roleId","default": "1"}
		 ] 
	}
	],
	"messages":{
		"test1":{
			  "doc": "Say hello.",  
		      "request": [
		      	{"name": "id", "type": "int" }
		      ],  
		      "response": "Role"
		},
		"test2":{
			  "doc": "test2.",  
		      "request": [{"name": "group", "type": "Group" }],  
		      "response": "null"
		}
	}
}
```
## 二、Protobuf技术
### 1.maven配置
```xml
<protobuf.version>3.5.1</protobuf.version>

<dependency>
    <groupId>com.google.protobuf</groupId>
    <artifactId>protobuf-java</artifactId>
    <version>${protobuf.version}</version>
</dependency>
```
### 2.protobuf-maven-plugin配置
1)com.github.igor-petruk.protobuf配置
```xml
<dependency>
    <groupId>io.grpc</groupId>
    <artifactId>grpc-all</artifactId>
    <version>1.9.0</version>
</dependency>

<plugin>
	<groupId>com.github.igor-petruk.protobuf</groupId>
	<artifactId>protobuf-maven-plugin</artifactId>
	<version>0.6.5</version>
	<executions>
	    <execution>
		<goals>
		    <goal>run</goal>
		</goals>
	    </execution>
	</executions>
	<configuration>
	    <inputDirectories><inputDirectory>${project.basedir}/src/main/resources/protobuf/</inputDirectory></inputDirectories>
	    <outputDirectory>${project.basedir}/src/main/java/</outputDirectory>
	</configuration>
</plugin>
```
2)org.xolstice.maven.plugins配置
```xml
<build>
	<extensions>
	      <extension>
			<groupId>kr.motd.maven</groupId>
			<artifactId>os-maven-plugin</artifactId>
			<version>1.5.0.Final</version>
	      </extension>
	</extensions>
</build>

<plugin>
	<groupId>org.xolstice.maven.plugins</groupId>
	<artifactId>protobuf-maven-plugin</artifactId>
	<version>0.5.1</version>
	<extensions>true</extensions>
	<configuration>
	    <protocArtifact>com.google.protobuf:protoc:3.5.1-1:exe:${os.detected.classifier}</protocArtifact>
			<pluginId>grpc-java</pluginId>
			<pluginArtifact>io.grpc:protoc-gen-grpc-java:1.9.0:exe:${os.detected.classifier}</pluginArtifact>
			<protoSourceRoot>${project.basedir}/src/main/resources/protobuf/</protoSourceRoot>
			<outputDirectory>${project.basedir}/src/main/java/</outputDirectory>
	</configuration>
	<executions>
	    <execution>
		<goals>
		    <goal>compile</goal>
		    <goal>compile-custom</goal>
		</goals>
	    </execution>
	</executions>
</plugin>
```
### 3.maven编译
1)com.github.igor-petruk.protobuf编译
```bash
mvn clean compile
```
2)org.xolstice.maven.plugins编译
```bash
mvn clean protobuf:compile
```

### 4.样例文件(*.proto)
```
syntax = "proto3";
option java_package = "com.ucloudlink.css.protobuf";
option java_outer_classname = "UserModel";

message User {
     int64 id = 1;//id主键
     string name = 2;
     string email = 3;
     int32 age = 4;//age
     bool sex = 5;
     repeated string list = 6;
     map<string,int64> map = 7;
}
```
proto3已经移除proto2中的required、optional、default等
## 三、thrift技术
### 1.maven配置
```xml
<thrift.version>0.10.0</thrift.version>

<dependency>
    <groupId>org.apache.thrift</groupId>
    <artifactId>libthrift</artifactId>
    <version>${thrift.version}</version>
</dependency>

<plugin>
	<groupId>org.apache.thrift.tools</groupId>
	<artifactId>maven-thrift-plugin</artifactId>
	<version>0.1.11</version>
	<configuration>
	    <thriftExecutable>${project.basedir}/src/main/resources/thrift</thriftExecutable>
	    <thriftSourceRoot>${project.basedir}/src/main/resources/thrift/</thriftSourceRoot>
	    <outputDirectory>${project.basedir}/src/main/java/</outputDirectory>
	</configuration>
	<executions>
	    <execution>
		<id>thrift-sources</id>
		<phase>generate-sources</phase>
		<goals>
		    <goal>compile</goal>
		</goals>
	    </execution>
	    <execution>
		<id>thrift-test-sources</id>
		<phase>generate-test-sources</phase>
		<goals>
		    <goal>testCompile</goal>
		</goals>
	    </execution>
	</executions>
</plugin>
```
### 2.maven编译
```bash
mvn clean compile
```
### 3.样例文件(*.thrift)
```
namespace java com.ucloudlink.css.thrift
service Hello{
    string helloString(1:string para)
}
```
