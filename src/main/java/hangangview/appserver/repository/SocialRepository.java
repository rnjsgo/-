package hangangview.appserver.repository;

import hangangview.appserver.domain.Question;
import hangangview.appserver.domain.Social;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SocialRepository extends JpaRepository<Social,Long> {
    List<Social> findAll();
}
