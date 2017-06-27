package eu.operando.swarmclient.models;

import org.json.JSONObject;

import java.io.Serializable;

/**
 * Created by Edy on 11/3/2016.
 */

public class Swarm implements Serializable {
    private SwarmMeta meta;

    public Swarm(String swarmingName, String phase, String command, String ctor, String tenantId, Object commandArguments) {
        meta = new SwarmMeta(swarmingName, phase, command, ctor, tenantId, commandArguments);
    }

    public Swarm(String swarmingName, String ctor, Object... commandArguments) {
        meta = new SwarmMeta(swarmingName, ctor, commandArguments);
    }

    public SwarmMeta getMeta() {
        return meta;
    }

    @Override
    public String toString() {
        return "Swarm{" +
                "meta=" + meta +
                '}';
    }

    public class SwarmMeta implements Serializable {
        //for sending swarm
        private String swarmingName;
        private String phase;
        private String command;
        private String ctor;
        private String tenantId;
        private Object[] commandArguments;

        //for receiving swarm
        private String currentPhase;
        private String sessionId;
        private String userId;


        private SwarmMeta(String swarmingName, String phase, String command, String ctor, String tenantId, Object... commandArguments) {
            this.swarmingName = swarmingName;
            this.phase = phase;
            this.command = command;
            this.ctor = ctor;
            this.tenantId = tenantId;
            this.commandArguments = commandArguments;
        }

        private SwarmMeta(String swarmingName, String ctor, Object... commandArguments) {
            this(swarmingName, "start", "start", ctor, "androidApp", commandArguments);
        }

        public String getSwarmingName() {
            return swarmingName;
        }

        public String getPhase() {
            return phase;
        }

        public String getCommand() {
            return command;
        }

        public String getCtor() {
            return ctor;
        }

        public String getTenantId() {
            return tenantId;
        }

        public Object getCommandArguments() {
            return commandArguments;
        }

        public String getCurrentPhase() {
            return currentPhase;
        }

        public String getSessionId() {
            return sessionId;
        }

        public String getUserId() {
            return userId;
        }

        @Override
        public String toString() {
            return "SwarmMeta{" +
                    "swarmingName='" + swarmingName + '\'' +
                    ", phase='" + phase + '\'' +
                    ", command='" + command + '\'' +
                    ", ctor='" + ctor + '\'' +
                    ", tenantId='" + tenantId + '\'' +
                    ", commandArguments=" + commandArguments +
                    ", currentPhase='" + currentPhase + '\'' +
                    ", sessionId='" + sessionId + '\'' +
                    ", userId='" + userId + '\'' +
                    '}';
        }
    }
}
