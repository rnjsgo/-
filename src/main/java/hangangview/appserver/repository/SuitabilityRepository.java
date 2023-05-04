package hangangview.appserver.repository;

import hangangview.appserver.domain.Question;
import hangangview.appserver.domain.Suitability;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface SuitabilityRepository extends JpaRepository<Suitability,Long> {
    List<Suitability> findAll();
}
