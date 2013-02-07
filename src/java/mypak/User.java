package mypak;

/**
 *
 * @author Marios
 */
public class User {

    private String First_Name;

    private String Last_Name;
    
    private Integer Role;

    private String email;
    
    private Integer id;
    
    private Integer department;

    public Integer getDepartment() {
        return department;
    }

    public void setDepartment(Integer department) {
        this.department = department;
    }
    
    public void setUser(User other)       
    {
    
        this.First_Name = other.getFirst_Name();
        this.Last_Name = other.getLast_Name();      
        this.Role = other.getRole();
        this.department = other.getDepartment();
        this.email = other.getEmail();        
    }

    public User(String First_Name, String Last_Name, Integer Role, String email, Integer id, Integer department) {
        this.First_Name = First_Name;
        this.Last_Name = Last_Name;
        this.Role = Role;
        this.email = email;
        this.id = id;
        this.department = department;
    }
    
    

    public User() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public User(String First_Name, String Last_Name, Integer Role, String email, Integer id) {
        this.First_Name = First_Name;
        this.Last_Name = Last_Name;
        this.Role = Role;
        this.email = email;
        this.id = id;
    }

    @Override
    public String toString() {
        return "User{" + "First_Name=" + First_Name + ", Last_Name=" + Last_Name + ", Role=" + Role + ", email=" + email + ", id=" + id + ", department=" + department + '}';
    }

    
   

    public User(String First_Name, String Last_Name, Integer Role, String email) {
        this.First_Name = First_Name;
        this.Last_Name = Last_Name;
        this.Role = Role;
        this.email = email;
    }

    public String getFirst_Name() {
        return First_Name;
    }

    public void setFirst_Name(String First_Name) {
        this.First_Name = First_Name;
    }

    public String getLast_Name() {
        return Last_Name;
    }

    public void setLast_Name(String Last_Name) {
        this.Last_Name = Last_Name;
    }

    public Integer getRole() {
        return Role;
    }

    public void setRole(Integer Role) {
        this.Role = Role;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    
    


}
