package com.enterpriseops.dto;

public class ManagerDashboardDTO {

    private long myTeam;
    private long activeProjects;
    private long openTasks;
    private long pendingLeaves;

    private long todoTasks;
    private long inProgressTasks;
    private long completedTasks;
    private long blockedTasks;

    public ManagerDashboardDTO() {
    }

    public long getMyTeam() {
        return myTeam;
    }

    public void setMyTeam(long myTeam) {
        this.myTeam = myTeam;
    }

    public long getActiveProjects() {
        return activeProjects;
    }

    public void setActiveProjects(long activeProjects) {
        this.activeProjects = activeProjects;
    }

    public long getOpenTasks() {
        return openTasks;
    }

    public void setOpenTasks(long openTasks) {
        this.openTasks = openTasks;
    }

    public long getPendingLeaves() {
        return pendingLeaves;
    }

    public void setPendingLeaves(long pendingLeaves) {
        this.pendingLeaves = pendingLeaves;
    }

    public long getTodoTasks() {
        return todoTasks;
    }

    public void setTodoTasks(long todoTasks) {
        this.todoTasks = todoTasks;
    }

    public long getInProgressTasks() {
        return inProgressTasks;
    }

    public void setInProgressTasks(long inProgressTasks) {
        this.inProgressTasks = inProgressTasks;
    }

    public long getCompletedTasks() {
        return completedTasks;
    }

    public void setCompletedTasks(long completedTasks) {
        this.completedTasks = completedTasks;
    }

    public long getBlockedTasks() {
        return blockedTasks;
    }

    public void setBlockedTasks(long blockedTasks) {
        this.blockedTasks = blockedTasks;
    }
}